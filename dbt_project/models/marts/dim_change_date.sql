with snapshot_stats as (

    select
        last_change_date,

        count(*) as rows_count,

        count(distinct barcode) as barcodes_count,

        count(distinct warehouse_name) as warehouses_count,

        sum(coalesce(total_stock, 0)) as total_stock

    from {{ ref('mart_warehouse_inventory_daily') }}

    where last_change_date is not null

    group by
        last_change_date

),

snapshot_dates as (

    select
        last_change_date,
        rows_count,
        barcodes_count,
        warehouses_count,
        total_stock,

        case
            when total_stock = 0 then 0
            when last_change_date in (
                '2022-03-26',
                '2022-03-27',
                '2022-04-20',
                '2022-06-29',
                '2022-07-15',
                '2022-07-18',
                '2022-07-22',
                '2022-07-29',
                '2022-07-30',
                '2022-08-02',
                '2022-08-06',
                '2022-08-08',
                '2022-08-15',
                '2022-08-19',
                '2022-08-26',
                '2022-09-02',
                '2022-09-14'
            ) then 0
            else 1
        end as is_valid_snapshot

    from snapshot_stats

),

date_attributes as (

    select
        last_change_date,

        rows_count,
        barcodes_count,
        warehouses_count,
        total_stock,
        is_valid_snapshot,

        extract(year from last_change_date)::int as year,

        date_trunc(
            'week',
            last_change_date
        )::date as week_start_date,

        to_char(
            date_trunc('week', last_change_date),
            'DD.MM'
        ) as week,

        to_char(
            last_change_date,
            'TMMonth YYYY'
        ) as month_year,

        date_trunc(
            'month',
            last_change_date
        )::date as month_start_date,

        extract(month from last_change_date)::int as month_number,

        date_trunc(
            'quarter',
            last_change_date
        )::date as quarter_start_date,

        extract(
            quarter from last_change_date
        )::int as quarter_number,

        'Q'
            || extract(
                quarter from last_change_date
            )::int
            || ' '
            || extract(
                year from last_change_date
            )::int as quarter,

        extract(day from last_change_date)::int as day,

        to_char(
            last_change_date,
            'DD.MM'
        ) as day_month

    from snapshot_dates

),

previous_periods as (

    select
        d.*,

        /*
            Предыдущий ВАЛИДНЫЙ snapshot.

            Например:
            05.09 -> предыдущего нет
            06.09 -> 05.09
            07.09 -> 06.09
            08.09 -> 06.09
            09.09 -> 08.09
        */
        (
            select max(p.last_change_date)

            from date_attributes p

            where p.last_change_date < d.last_change_date
              and p.is_valid_snapshot = 1

        ) as previous_day_snapshot_date,

        /*
            Предыдущий ВАЛИДНЫЙ snapshot
            в предыдущей календарной неделе.
        */
        (
            select max(p.last_change_date)

            from date_attributes p

            where p.week_start_date =
                  d.week_start_date - interval '7 days'

              and p.is_valid_snapshot = 1

        ) as previous_week_snapshot_date,

        /*
            Предыдущий ВАЛИДНЫЙ snapshot
            в предыдущем календарном месяце.
        */
        (
            select max(p.last_change_date)

            from date_attributes p

            where p.month_start_date =
                  d.month_start_date - interval '1 month'

              and p.is_valid_snapshot = 1

        ) as previous_month_snapshot_date,

        /*
            Предыдущий ВАЛИДНЫЙ snapshot
            в предыдущем календарном квартале.
        */
        (
            select max(p.last_change_date)

            from date_attributes p

            where p.quarter_start_date =
                  d.quarter_start_date - interval '3 months'

              and p.is_valid_snapshot = 1

        ) as previous_quarter_snapshot_date

    from date_attributes d

)

select
    *,

    to_char(
        last_change_date,
        'YYYYMMDD'
    )::int as date_code,

    to_char(
        week_start_date,
        'YYYYMMDD'
    )::int as week_code,

    to_char(
        month_start_date,
        'YYYYMM'
    )::int as month_code,

    (
        extract(year from last_change_date)::int * 10
        + quarter_number
    ) as quarter_code

from previous_periods