use EntertainmentAgency;

--Top agents with the max contract in the last quarter
select top (3) with ties 
		CONCAT(a.agtfirstname, ' ', a.AgtLastName) as agent, max(e.ContractPrice) as maxContractPrice
from Agents as a
left join Engagements as e
	on e.AgentID = a.AgentID
where e.StartDate >= dateadd(month, -3, StartDate)
	and e.StartDate <= StartDate
group by CONCAT(a.agtfirstname, ' ', a.AgtLastName)
order by maxContractPrice desc;

-- average for the last quarters  
select case
		when MONTH(StartDate) in (9, 10, 11) then '1st Quarter'
        when MONTH(StartDate) in (12, 1, 2) then '2nd Quarter'
        when MONTH(StartDate) in (3, 4, 5) then '3rd Quarter'
        else '4th Quarter'
	end as Quarters,
round(avg(contractprice), 2) as avgContractPrice
from Engagements
group by case
		when MONTH(StartDate) in (9, 10, 11) then '1st Quarter'
        when MONTH(StartDate) in (12, 1, 2) then '2nd Quarter'
        when MONTH(StartDate) in (3, 4, 5) then '3rd Quarter'
        else '4th Quarter'
	end
order by quarters;

--closed engagements
select CONCAT(a.agtfirstname, ' ', a.AgtLastName) as agent, COUNT(e.engagementnumber) as TotalEngagements
from Agents as a
left join Engagements as e
	on e.AgentID = a.AgentID
group by CONCAT(a.agtfirstname, ' ', a.AgtLastName);

--Entertainers used by agents in engagements
select CONCAT(a.agtfirstname, ' ', a.AgtLastName) as agent, et.EntStageName, COUNT(e.engagementnumber) as TotalEngagements
from Agents as a
left join Engagements as e
	on e.AgentID = a.AgentID
left join Entertainers as et
	on et.EntertainerID = e.EntertainerID
group by CONCAT(a.agtfirstname, ' ', a.AgtLastName), et.EntStageName
order by agent desc;

--Average commison rate
select CONCAT(agtfirstname, ' ', AgtLastName) as agent, round(AVG(commissionrate), 4)*100 as avgCommissionRate
from Agents
group by CONCAT(agtfirstname, ' ', AgtLastName)

--average number of contracts per agent in the last quarter
select CONCAT(a.agtfirstname, ' ', a.AgtLastName) as agent, round(avg(e.contractprice), 2) as avgcontractAmount
from Engagements as e
left join Agents as a
	on a.AgentID = e.AgentID
where e.StartDate between dateadd(month, -3, StartDate)
	and e.StartDate
group by CONCAT(agtfirstname, ' ', AgtLastName);

--average contract price for engagements in each month
select case
		when month(StartDate) = 1 then 'Jan'
		when month(StartDate) = 2 then 'Feb'
		when month(StartDate) = 3 then 'Mar'
		when month(StartDate) = 4 then 'Apr'
		when month(StartDate) = 5 then 'May'
		when month(StartDate) = 6 then 'Jun'
		when month(StartDate) = 7 then 'Jul'
		when month(StartDate) = 8 then 'Aug'
		when month(StartDate) = 9 then 'Sep'
		when month(StartDate) = 10 then 'Oct'
		when month(StartDate) = 11 then 'Nov'
		else 'Dec'
	end as 'Month',
avg(contractprice) as avgContractPrice
from Engagements
group by case
		when month(StartDate) = 1 then 'Jan'
		when month(StartDate) = 2 then 'Feb'
		when month(StartDate) = 3 then 'Mar'
		when month(StartDate) = 4 then 'Apr'
		when month(StartDate) = 5 then 'May'
		when month(StartDate) = 6 then 'Jun'
		when month(StartDate) = 7 then 'Jul'
		when month(StartDate) = 8 then 'Aug'
		when month(StartDate) = 9 then 'Sep'
		when month(StartDate) = 10 then 'Oct'
		when month(StartDate) = 11 then 'Nov'
		else 'Dec'
	end;