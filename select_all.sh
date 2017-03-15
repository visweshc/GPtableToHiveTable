for i in `cat ac170_wm_ad_hoc_table_list.txt`
do
echo "select count(1) from  $i ;" >> select.sql
echo "select * from $i limit 3 ;" >> select.sql
done

