DECLARE @DIEM FLOAT
SET @DIEM =10
-- nhieu hon 1 lenh sai begin va end
IF(@DIEM >=5) 
begin
print 'PASS'
print 'happy' 
end
else print 'not pass'
	

declare @marks float = 7
if @marks >=9 
print N'giỏi'
else if @marks >=7.5
print N'khá'
else if @marks >=5
print N'trung binh'
else if @marks <5
print N'yeu'
else print N'Không hợp lê'
