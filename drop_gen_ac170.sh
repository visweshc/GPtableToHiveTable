export PGPASSWORD='Parents@123'
for i in `cat ac170_wm_ad_hoc_table_list.txt`
do
echo "drop table $i ;" >> drop.sql
done

