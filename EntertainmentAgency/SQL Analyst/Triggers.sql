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


-- create CustomersAudit table
create table CustomersAudit (
    AuditID INT PRIMARY KEY IDENTITY(1,1),
    ActionType VARCHAR(10),
    CustomerID INT,
    AuditDate DATETIME,
    ModifiedBy NVARCHAR(100)
);

--update customers audit table to check who made change
create trigger tr_AuditCustomersChanges on Customers
after insert, update, delete as
	begin
	set nocount on;
	
	insert into CustomersAudit (ActionType, CustomerID, AuditDate, ModifiedBy)
    select
        case
            when exists (select * from inserted) and exists (select * from deleted) then 'UPDATE'
            when exists (select * from inserted) then 'INSERT'
            when exists (select * from deleted) then 'DELETE'
        end,
        ISNULL(i.CustomerID, d.CustomerID),
        getdate(),
        SYSTEM_USER
    from inserted i
    full outer join deleted d on i.CustomerID = d.CustomerID;
	end;
