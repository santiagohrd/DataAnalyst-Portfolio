use EntertainmentAgency;

--Entertainers with the highest number of days in performance
select et.EntStageName, sum(datediff(day, e.StartDate, e.EndDate)) as dayDuration
from Engagements as e
left join Entertainers as et
	on et.EntertainerID = e.EntertainerID
group by et.EntStageName
order by dayDuration desc;

--Number of days in presentation per month
select MONTH(e.startdate) as month, et.EntStageName,
	sum(datediff(day, e.startdate, e.enddate)) as DayDuration,
	sum(sum(datediff(day, e.startdate, e.enddate))) over (partition by MONTH(e.startdate)) as CountDaysinPerformance
from Engagements as e
left join Entertainers as et
	on et.EntertainerID = e.EntertainerID
group by month(startdate), et.EntStageName
order by 1;
