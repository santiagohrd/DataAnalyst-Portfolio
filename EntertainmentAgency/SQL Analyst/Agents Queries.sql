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

--
