insert into Account
values(N'K9',N'RongK9',N'111111',1)
go
insert into Account
values(N'staff',N'staff',N'111111',0)
go
create proc USP_GetAccountByUserName
@userName nvarchar(100)
as
begin 
select * from Account where UserName = @userName
end
go
exec USP_GetAccountByUserName @userName = N'K9'

go
create proc USP_Login
@userName nvarchar(100), @passWord nvarchar(100)
as
begin 
select * from Account where UserName = @userName and PassWord =@passWord
end
go
select * from  Account where UserName = N'k9'
go
exec USP_GetAccountByUserName @userName = N'K9'
 
 go
 declare @i int = 0
while @i <=10
begin
	insert into TableFood (name) values (N'Bàn '+CAST(@i AS nvarchar(100)))
	set @i = @i +1
end

go
delete from TableFood

go
 create proc USP_GetTableList 
 as
 begin
	select * from TableFood
 end

 go
 exec USP_GetTableList
 go
 delete from TableFood

 go
 declare @i int = 0
while @i <=10
begin
	update TableFood set id = @i where id<=34 and id>=24
	set @i = @i +1
	
end

go
update TableFood 
set status = N'Có người' 
where id = 30

go
select * from Bill 
go
select *from Food
go
select *from Billinfo
go
select *from FoodCategory

go
insert FoodCategory(name)
values (N'Hải sản')

go
insert FoodCategory(name)
values (N'Nông sản')

go
insert FoodCategory(name)
values (N'Lâm sản')

go
insert FoodCategory(name)
values (N'Nước')


go
insert Food(name ,idCategory , price)
values (N'Mực nướng',1,120000)

go
insert Food(name ,idCategory , price)
values (N'Nghêu hấp xả',1,50000)

go
insert Food(name ,idCategory , price)
values (N'Cháo hến',1,35000)

go
insert Food(name ,idCategory , price)
values (N'Heo rừng nướng muối ớt',2,1200000)

go
insert Food(name ,idCategory , price)
values (N'Cơm chiên muối',2,15000)

go
insert Food(name ,idCategory , price)
values (N'7up',4,8000)

go
insert Food(name ,idCategory , price)
values (N'Bia haniken',4,10000)

go
insert Bill(DateCheckIn,DateCheckOut,idTable,status)
values(GETDATE(),null,24,0)

go
insert Bill(DateCheckIn,DateCheckOut,idTable,status)
values(GETDATE(),null,27,0)

go
insert Bill(DateCheckIn,DateCheckOut,idTable,status)
values(GETDATE(),null,30,0)

go
insert Bill(DateCheckIn,DateCheckOut,idTable,status)
values(GETDATE(),null,30,0)

go
insert Billinfo(idBill,idFood,count)
values(7,3,4)


go
insert Billinfo(idBill,idFood,count)
values(7,2,3)

go
insert Billinfo(idBill,idFood,count)
values(8,2,1)

go
insert Billinfo(idBill,idFood,count)
values(8,4,2)

go
insert Billinfo(idBill,idFood,count)
values(9,3,2)


go
insert Billinfo(idBill,idFood,count)
values(3,2,4)

go
use QuanLyQuanCafe
go
select f.name, bi.count,f.price,f.price*bi.count as totalPrice from Billinfo as bi, Bill as b, Food as f  
where bi.idBill = b.id and bi.idFood = f.id and b.idTable = 24

go
use QuanLyQuanCafe
go
alter proc USP_InsertBill
@idTable int 
as
begin
	insert into Bill(DateCheckIn,DateCheckOut,idTable,status,discount)
	values(GETDATE() , Null,@idTable,0,0)
end

go
alter proc USP_InsertBillInfo
@idBill int , @idFood int ,@count int
as
begin
	declare @isExitsBillInfo int 
	declare @foodCount int = 1
	select @isExitsBillInfo = id , @foodCount=b.count from Billinfo as b where idBill =@idBill and idFood =@idFood
	if(@isExitsBillInfo>0)
	begin
		declare @newCount int = @foodCount + @count 
		if(@newCount>0)
			update Billinfo set count = @foodCount + @count where idFood = @idFood
		else
			delete from Billinfo where idBill = @idBill and idFood = @idFood
	end
	else 
	begin
		insert into Billinfo(idBill,idFood,count)
	values (@idBill,@idFood,@count)
	end
	
end
go
select max(id) from Bill
go
update Bill set status =1 where id = 1

go
delete Billinfo
delete Bill

go
alter trigger UTG_updateBillInfo
ON dbo.BillInfo FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @idBill INT
	
	SELECT @idBill = idBill FROM Inserted
	
	DECLARE @idTable INT
	
	SELECT @idTable = idTable FROM dbo.Bill WHERE id = @idBill AND status = 0	
	
	DECLARE @count INT
	SELECT @count = COUNT(*) FROM dbo.BillInfo WHERE idBill = @idBill
	
	IF (@count > 0)
	BEGIN
	
		PRINT @idTable
		PRINT @idBill
		PRINT @count
		
		UPDATE dbo.TableFood SET status = N'Có người' WHERE id = @idTable		
		
	END		
	ELSE
	BEGIN
	PRINT @idTable
		PRINT @idBill
		PRINT @count
	UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable	
	end
	
END

go
create trigger UTG_updateBill
on dbo.Bill for update
as
begin
	declare @idBill int
	
	select @idBill = id FROM Inserted	
	
	declare @idTable int
	
	select @idTable = idTable FROM dbo.Bill where id = @idBill
	
	declare @count int = 0
	
	select @count = COUNT(*) FROM dbo.Bill where idTable = @idTable AND status = 0
	
	IF (@count = 0)
		update dbo.TableFood set status = N'Trống' where id = @idTable
END

go
alter table Bill add discount
go
update Bill set discount = 0

declare @idBillNew int = 19
select id into IDBillInfoTable from Billinfo where idBill = @idBillNew
declare @idBillOld int =10
update Billinfo set idBill = @idBillOld where id in (select * from IDBillInfoTable)
go
create PROC USP_SwitchTabel
@idTable1 INT, @idTable2 int
AS BEGIN

	DECLARE @idFirstBill int
	DECLARE @idSeconrdBill INT
	
	DECLARE @isFirstTablEmty INT = 1
	DECLARE @isSecondTablEmty INT = 1
	
	
	SELECT @idSeconrdBill = id FROM dbo.Bill WHERE idTable = @idTable2 AND status = 0
	SELECT @idFirstBill = id FROM dbo.Bill WHERE idTable = @idTable1 AND status = 0
	
	PRINT @idFirstBill
	PRINT @idSeconrdBill
	PRINT '-----------'
	
	IF (@idFirstBill IS NULL)
	BEGIN
		PRINT '0000001'
		INSERT dbo.Bill
		        ( DateCheckIn ,
		          DateCheckOut ,
		          idTable ,
		          status
		        )
		VALUES  ( GETDATE() , -- DateCheckIn - date
		          NULL , -- DateCheckOut - date
		          @idTable1 , -- idTable - int
		          0  -- status - int
		        )
		        
		SELECT @idFirstBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable1 AND status = 0
		
	END
	
	SELECT @isFirstTablEmty = COUNT(*) FROM dbo.BillInfo WHERE idBill = @idFirstBill
	
	PRINT @idFirstBill
	PRINT @idSeconrdBill
	PRINT '-----------'
	
	IF (@idSeconrdBill IS NULL)
	BEGIN
		PRINT '0000002'
		INSERT dbo.Bill
		        ( DateCheckIn ,
		          DateCheckOut ,
		          idTable ,
		          status
		        )
		VALUES  ( GETDATE() , -- DateCheckIn - date
		          NULL , -- DateCheckOut - date
		          @idTable2 , -- idTable - int
		          0  -- status - int
		        )
		SELECT @idSeconrdBill = MAX(id) FROM dbo.Bill WHERE idTable = @idTable2 AND status = 0
		
	END
	
	SELECT @isSecondTablEmty = COUNT(*) FROM dbo.BillInfo WHERE idBill = @idSeconrdBill
	
	PRINT @idFirstBill
	PRINT @idSeconrdBill
	PRINT '-----------'

	SELECT id INTO IDBillInfoTable FROM dbo.BillInfo WHERE idBill = @idSeconrdBill
	
	UPDATE dbo.BillInfo SET idBill = @idSeconrdBill WHERE idBill = @idFirstBill
	
	UPDATE dbo.BillInfo SET idBill = @idFirstBill WHERE id IN (SELECT * FROM IDBillInfoTable)
	
	DROP TABLE IDBillInfoTable
	
	IF (@isFirstTablEmty = 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable2
		
	IF (@isSecondTablEmty= 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable1
END
GO
select * from Bill
delete Billinfo
delete Bill
go
alter proc USP_GetListBillByDate
@checkIn date, @checkOut date
as
begin
	select t.name as[Tên bàn],DateCheckIn as [Ngày vào],DateCheckOut as [Ngay ra],discount as [Giam giá],b.totalPrice as [Tổng tiền] from Bill as b, TableFood as t 
	where DateCheckIn >=@checkIn and DateCheckOut <=@checkOut and b.status =1 and b.idTable = t.id
end
go
alter table Bill add totalPrice float
go
exec USP_GetListBillByDate @checkIn = '20180930',  @checkOut='20180930'
go
select * from Bill
select * from Account



go
CREATE PROC USP_UpdateAccount
@userName NVARCHAR(100), @displayName NVARCHAR(100), @password NVARCHAR(100), @newPassword NVARCHAR(100)
AS
BEGIN
	DECLARE @isRightPass INT = 0
	
	SELECT @isRightPass = COUNT(*) FROM dbo.Account WHERE USERName = @userName AND PassWord = @password
	
	IF (@isRightPass = 1)
	BEGIN
		IF (@newPassword = NULL OR @newPassword = '')
		BEGIN
			UPDATE dbo.Account SET DisplayName = @displayName WHERE UserName = @userName
		END		
		ELSE
			UPDATE dbo.Account SET DisplayName = @displayName, PassWord = @newPassword WHERE UserName = @userName
	end
END
GO

CREATE TRIGGER UTG_DeleteBillInfo
ON dbo.BillInfo FOR DELETE
AS 
BEGIN
	DECLARE @idBillInfo INT
	DECLARE @idBill INT
	SELECT @idBillInfo = id, @idBill = Deleted.idBill FROM Deleted
	
	DECLARE @idTable INT
	SELECT @idTable = idTable FROM dbo.Bill WHERE id = @idBill
	
	DECLARE @count INT = 0
	
	SELECT @count = COUNT(*) FROM dbo.BillInfo AS bi, dbo.Bill AS b WHERE b.id = bi.idBill AND b.id = @idBill AND b.status = 0
	
	IF (@count = 0)
		UPDATE dbo.TableFood SET status = N'Trống' WHERE id = @idTable
END
GO

CREATE FUNCTION [dbo].[fuConvertToUnsign1] ( @strInput NVARCHAR(4000) ) RETURNS NVARCHAR(4000) AS BEGIN IF @strInput IS NULL RETURN @strInput IF @strInput = '' RETURN @strInput DECLARE @RT NVARCHAR(4000) DECLARE @SIGN_CHARS NCHAR(136) DECLARE @UNSIGN_CHARS NCHAR (136) SET @SIGN_CHARS = N'ăâđêôơưàảãạáằẳẵặắầẩẫậấèẻẽẹéềểễệế ìỉĩịíòỏõọóồổỗộốờởỡợớùủũụúừửữựứỳỷỹỵý ĂÂĐÊÔƠƯÀẢÃẠÁẰẲẴẶẮẦẨẪẬẤÈẺẼẸÉỀỂỄỆẾÌỈĨỊÍ ÒỎÕỌÓỒỔỖỘỐỜỞỠỢỚÙỦŨỤÚỪỬỮỰỨỲỶỸỴÝ' +NCHAR(272)+ NCHAR(208) SET @UNSIGN_CHARS = N'aadeoouaaaaaaaaaaaaaaaeeeeeeeeee iiiiiooooooooooooooouuuuuuuuuuyyyyy AADEOOUAAAAAAAAAAAAAAAEEEEEEEEEEIIIII OOOOOOOOOOOOOOOUUUUUUUUUUYYYYYDD' DECLARE @COUNTER int DECLARE @COUNTER1 int SET @COUNTER = 1 WHILE (@COUNTER <=LEN(@strInput)) BEGIN SET @COUNTER1 = 1 WHILE (@COUNTER1 <=LEN(@SIGN_CHARS)+1) BEGIN IF UNICODE(SUBSTRING(@SIGN_CHARS, @COUNTER1,1)) = UNICODE(SUBSTRING(@strInput,@COUNTER ,1) ) BEGIN IF @COUNTER=1 SET @strInput = SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)-1) ELSE SET @strInput = SUBSTRING(@strInput, 1, @COUNTER-1) +SUBSTRING(@UNSIGN_CHARS, @COUNTER1,1) + SUBSTRING(@strInput, @COUNTER+1,LEN(@strInput)- @COUNTER) BREAK END SET @COUNTER1 = @COUNTER1 +1 END SET @COUNTER = @COUNTER +1 END SET @strInput = replace(@strInput,' ','-') RETURN @strInput END
go
select * from FoodCategory 
go
insert into FoodCategory values(N'Loai moi')
go
delete FoodCategory where id = 6
go
update FoodCategory set name = 'Loai moi 1' where id = 5
go
select * from TableFood
go
insert into TableFood values( N'Bàn 11',N'Trống')
go 
alter table TableFood add CONSTRAINT unique_name unique(name) 
go
go 
alter table FoodCategory add constraint unique_name_FoodCategory unique(name)
go
alter table Food add constraint unique_name_Food unique(name)
go 
select * from Account
go
alter table Account add constraint unique_Displayname unique(DisplayName)