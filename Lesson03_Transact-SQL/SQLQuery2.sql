/* A. DDL */
	--1. CREATE 
	--2. ALTER 
	--3. DROP
	
/* B. DML */
	--1. SELECT
	--Syntax: [SELECT] [Fields_list] [FROM] [Table_name]
		--Ex:
			select CName, CPhone from Customer
			select ICode, ItemName, Rate from Item
			--------------------------------------
			select * 
			from	 OrderDetails
			where	 OrderNo = '0083/98' and
					(Qty = 100 or Qty = 50)

			
	--2. INSERT
		--2.1. Insert one record: [INSERT INTO] [Table_name] [VALUES] [(Value_list)] 
			insert into Item values('FPT01', 'FPT name 01', 1)
		
		--2.2. Insert one record: [INSERT INTO] [Table_name] [VALUES] [(Value_list_1),... (Value_list_n)] 
			insert into Item values ('FPT02', 'FPT name 02', 2),
									('FPT03', 'FPT name 03', 3),
									('FPT04', 'FPT name 04', 4)

		--2.3. Insert select field: [INSERT INTO] [Table_name](Field_List) [VALUES] [(Value_list)]
			insert into Item(ICode, ItemName) values('FPT05', 'FPT name 05')

		--2.4 Insert unicode value: [INSERT INTO] [Table_name] [VALUES] [(N' Unicode_Value_1', Value_list...)] 
			insert into Item values ('FPT06', N'Tên của FPT6 06', 6)
			
	--3. UPDATE
	--Syntax: [UPDATE] [Table_name] [SET] [Expression] [Filter]
		--Ex: 
			update Item 
			set	Rate = 0 
			where ICode = 'FPT01'
			---------------------
			update Item 
			set Rate = 1 
			where ICode like 'FPT%' --wildcard (% là tính bắt đầu hoặc cuối (%fpt: cuối) (fpt%: đầu) )
			
	--4. DELETE (from)
		delete from Item  
		where ICode like 'FPT%' -- xóa tất cả fpt có trong bản 
		