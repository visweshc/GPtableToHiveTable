export PGPASSWORD='Parents@123'
for i in `cat ac170_wm_ad_hoc_table_list.txt`
do
#hive -e "use dsadm ; show create table $i" >> ac170_wm_ad_hoc_table_list.ddl
#echo "drop external table $i;" >> drop_ac170_wm_ad_hoc_table_list.ddl
#echo "select * from $i limit 5;" >> data_ac170_wm_ad_hoc_table_list.txt
#echo "select count(1) from $i ;" >> data_ac170_wm_ad_hoc_table_list.txt
pg_dump -t ac170_wm_ad_hoc.$i -s -x  -h gpprod1 -p 5432 -U dba_vicho1 >> /home/gpadmin/ac170/$i.sql
sed -i 's/CREATE TABLE/CREATE EXTERNAL TABLE/'  /home/gpadmin/ac170/$i.sql
sed -i 's/character varying/varchar/'  /home/gpadmin/ac170/$i.sql
sed -i 's/numeric(50,2)/decimal(38,2)/' /home/gpadmin/ac170/$i.sql
sed -i 's/numeric/decimal/'  /home/gpadmin/ac170/$i.sql
sed -i 's/text/string/'  /home/gpadmin/ac170/$i.sql
sed -i 's/unknown/string/' /home/gpadmin/ac170/$i.sql
#sed -i 's/DISTRIBUTED/;\n/'  /home/gpadmin/ac170/$i.sql
#cat /home/gpadmin/ac170/$i.sql |  awk 'RS="";/CREATE TABLE[^;]*;/' > temp_$i.sql
cat  /home/gpadmin/ac170/$i.sql | awk 'RS="";/CREATE EXTERNAL TABLE[^;]/{print}' | sed '/DISTRIBUTED/d' >>  /home/gpadmin/ac170/temp_$i.sql
echo ")"  >>  /home/gpadmin/ac170/temp_$i.sql
cat /home/gpadmin/ac170/template.sql >> /home/gpadmin/ac170/temp_$i.sql
echo " 'hdfs://prod14ha/user/dsadm/warehouse/ac170_wm_ad_hoc/$i' " >> /home/gpadmin/ac170/temp_$i.sql
echo ";" >> /home/gpadmin/ac170/temp_$i.sql
sed -i 's/varchar,/varchar(300),/'  /home/gpadmin/ac170/temp_$i.sql
sed -i 's/decimal(50/decimal(38/' /home/gpadmin/ac170/temp_$i.sql
cat /home/gpadmin/ac170/temp_$i.sql >>   /home/gpadmin/ac170/ac170_wm_ad_hoc_all.sql
rm /home/gpadmin/ac170/temp_$i.sql
rm /home/gpadmin/ac170/$i.sql
done

