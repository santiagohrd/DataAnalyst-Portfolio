USE EntertainmentAgency;

--Getting to know the tables and columns of the database
SELECT table_name, column_name, data_type, character_maximum_length, is_nullable
FROM INFORMATION_SCHEMA.COLUMNS;

--most popular music styles
select StyleName, mp.PreferenceSeq
from Musical_Styles as ms
inner join Musical_Preferences as mp
on ms.StyleID = mp.StyleID
where mp.PreferenceSeq = (
	select max(PreferenceSeq) from Musical_Preferences);

--Entertainments most required
select e.EntStageName, count(eg.EngagementNumber) as NumEngagements
from Entertainers as e
inner join Engagements as eg
	on eg.EntertainerID = e.EntertainerID
group by e.EntStageName
order by NumEngagements desc;

--top three cities with the most engaged customers
select top(3) c.CustState, c.CustCity, count(EngagementNumber) as NumEngagements
from customers as c
inner join Engagements as e
	on e.CustomerID = c.CustomerID
group by c.CustState, c.CustCity
order by NumEngagements desc;

--Count of member by city
select CustCity, COUNT(CustCity) as NumMembers
from Customers
group by CustCity;

--Number of advisories per client per agent, and prices
select CONCAT(custFirstName, ' ', CustLastName) as CustName, CONCAT(agtfirstname, ' ', agtlastname) as agentName, 
		count(engagementnumber) as NumAdvices,
		SUM(e.contractprice) as sumContractPrice,
		SUM(COUNT(engagementnumber)) OVER(PARTITION BY CONCAT(c  me, ' ', CustLastName)) AS TotalAdvicesByCustomer,
		sum(count(contractprice)) over(partition by concat(
from Customers as c
left join Engagements as e
on c.CustomerID = e.CustomerID
left join Agents as a
on a.AgentID = e.AgentID
group by CONCAT(custFirstName, ' ', CustLastName), CONCAT(agtfirstname, ' ', agtlastname)
order by TotalAdvicesByCustomer desc;
