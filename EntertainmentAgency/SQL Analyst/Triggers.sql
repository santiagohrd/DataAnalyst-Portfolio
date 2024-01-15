--enforce constraints on date fields
create trigger tr_EnforceDateConstraints on engagements
	after insert, update as
		begin
			set nocount on;
			if (select count(*) from inserted where StartDate > EndDate) >	0
		
			begin
				throw 50000, 'Start date must be less than or equal to End date.', 1;
				rollback;
			end
		end;

--Enforce email format
create trigger tr_enforceEmailFormat on	entertainers
	after insert, update as
		begin
			set nocount on;
			if (select count(*) from inserted where not EntEMailAddress like '%@%') > 0

			begin
				throw 50001, 'Invalid email format', 1;
				rollback;
			end
		end;

--Prevent salary decrease
create trigger tr_preventSalayDecrease on agents
	after update as
		begin
			set nocount on;
			if(select count(*) from inserted where Salary < (select Salary from deleted)) > 0
		
			begin
				throw 50002, 'Salary cannot be decreased', 1;
				rollback;
			end
		end;