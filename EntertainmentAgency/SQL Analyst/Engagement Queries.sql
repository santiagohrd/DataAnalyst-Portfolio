use EntertainmentAgency;

--Entertainers with the highest number of days in performance
select et.EntStageName, sum(datediff(day, e.StartDate, e.EndDate)) as dayDuration
from Engagements as e
left join Entertainers as et
	on et.EntertainerID = e.EntertainerID
group by et.EntStageName
order by dayDuration desc;

-- presentations by month and total year
select et.EntStageName, 
	count(case when month(startdate) = 1 then 1 else null end) as Jan,
	count(case when month(startdate) = 2 then 1 else null end) as Feb,
	count(case when month(startdate) = 3 then 1 else null end) as Mar,
	count(case when month(startdate) = 4 then 1 else null end) as Apr,
	count(case when month(startdate) = 5 then 1 else null end) as May,
	count(case when month(startdate) = 6 then 1 else null end) as Jun,
	count(case when month(startdate) = 7 then 1 else null end) as Jul,
	count(case when month(startdate) = 8 then 1 else null end) as Aug,
	count(case when month(startdate) = 9 then 1 else null end) as Sep,
	count(case when month(startdate) = 10 then 1 else null end) as Oct,
	count(case when month(startdate) = 11 then 1 else null end) as Nov,
	count(case when month(startdate) = 12 then 1 else null end) as Dec,
	sum(count(month(startdate))) over (partition by et.EntStageName) as CountTotalYear
from Engagements as e
left join Entertainers as et
	on e.EntertainerID = et.EntertainerID
--where month(startdate) = 9
group by et.EntStageName
having count(case when month(e.startdate) > 0 then 1 else null end) >= 1;

--event duration vs. contract price
select EngagementNumber
	, sum(datediff(day, startdate, enddate) + 1) as DayDuration --I decided to add 1, since single-day contracts were being zeroed out, generating an incomplete display of the total number of days.
	, ContractPrice,
	case
		when sum(datediff(day, startdate, enddate)) > 0 then 
		round(ContractPrice / nullif(sum(datediff(day, startdate, enddate)),0),2)
		else ContractPrice
	end as priceDay
from Engagements
group by EngagementNumber, ContractPrice
having ContractPrice > 1500;

--
