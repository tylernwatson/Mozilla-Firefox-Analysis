/*Question 1*/

/*How many total users completed the survey*/

select count(distinct user_id)
from survey
;

/*4081 users responded. This is 14.8% of total users*/

/*How many total users are in the database*/

select count(distinct id)
from users
;

/*27627 users. 14.8% completed the survey*/

/*How many users responded to the survey and used Firefox (had an event recorded) during the sample week*/

select count(distinct events.user_id)
from events inner join survey
on events.user_id = survey.user_id
;

/*2280 people answered the survey and had an event recorded, which is 8.3%*/


/*What fraction use Firefox as their primary browser*/

select *
from survey 
where survey.q4 = '0' or survey.q4 = '1'
;

/*3361 our of 4081 survey respondents use Firefox as their primary browser, which is 82.4%*/

/*What fraction of survey respondents do not use Firefox as their primary browser*/

select *
from survey
where q4 = '2' or q4 = '3' or q4 = '4' or q4 = '5'
;

/*440 survey respondents do not use Firefox as their primary browser. Since 4081 people responded, that is 9.2% of total respondents*/

/*How did people respond to the primary browser question*/

select user_id, q4
from survey
where q4 is not null
;

/*3801 respondents. Analysis of the response breakdown in Excel tab 'non firefox internet use*/

/*What fraction of users have been using Firefox for less than 90 days*/

select *
from survey
where q1 = '0'
;

/*215 out of 4081 survey respondents, so 5.3%*/

/*What fraction of users who use Firefox as their primary browser have been using Firefox for less than 90 days*/

select *
from survey
where q1 = '0' and (q4 = '0' or q4 = '1')
;

/*139 out of 3361 primary Firefox users have been using Firefox for less than 90 days, which is 4.1%*/

/*What fraction of users who do not use Firefox as their primary browser have been using it for less than 90 days*/

select *
from survey
where q1 = '0' and (q4 = '2' or q4 = '3' or q4 = '4' or q4 = '5')
;

/*57 out of 440 survey respondents who do not use Firefox as their primary browser have been using it for less than 90 days. This is 13%*/

/*What fraction have been using it over 365 days*/

select *
from survey
where q1 = '3' or q1 = '4' or q1 = '5' or q1 = '6'
;

/*3701 out of 4081 survey respondents, so 90.7%/

/*What fraction of survey respondents who use Firefox as their primary browser have been using it over 365 days*/

select *
from survey
where (q1 = '3' or q1 = '4' or q1 = '5' or q1 = '6') and (q4 = '0' or q4 = '1')
;

/*3119 out of 3361 primary Firefox users have been using it for over a year, which is 92.8%*/ 

/*What fraction of survey respondents who do not use Firefox as their primary browser have been using it over 365 days*/

select *
from survey
where (q1 = '3' or q1 = '4' or q1 = '5' or q1 = '6') and (q4 = '2' or q4 = '3' or q4 = '4' or q4 = '5')
;

/*350 rows out of 440 survey respondents who do not use Firefox as their primary browser, so 80%*/

/*Of those who use it as primary browser, analyze distro*/

select user_id, q1
from survey
where q4 = '2' or q4 = '3' or q4 = '4' or q4 = '5'
;

/*In Excel spreadsheet 'firefox user length distribution*/

/*Of those who don't, analyze distro*/

select user_id, q1
from survey
where q4 = '0' or q4 = '1'
;

/*In Excel spreadsheet 'firefox user length distribution*/

/*Question 2*/

/*What is the average number of bookmarks*/

select avg(cast(left(events.data1,(position(' ' in events.data1))) as integer)) as avg_bookmarks
into temp avg_bookmarks_all
from events inner join survey
on events.user_id = survey.user_id
where events.event_code = 8
;

/*The average number of bookmarks for a Firefox user is 234.6. */

/*Average number of bookmarks for those who use Firefox as primary browser*/

select events.user_id, avg(cast(left(events.data1,(position(' ' in events.data1))) as integer)) as bookmarks
from events inner join survey
on events.user_id = survey.user_id
where events.event_code = 8 and (survey.q4 = '0' or survey.q4 = '1')
group by events.user_id
order by 1 asc
;

/*Average number of bookmarks for those who do not use Firefox as a primary browser*/

select events.user_id, avg(cast(left(events.data1,(position(' ' in events.data1))) as integer)) as bookmarks
from events inner join survey
on events.user_id = survey.user_id
where events.event_code = 8 and (survey.q4 = '2' or survey.q4 = '3' or survey.q4 = '4' or survey.q4 = '5')
group by events.user_id
order by 1 asc
;

/*I put this data set in Excel and removed outliers beyond two standard deviations then created histograms showing the distribution*/

/*What is the average number of bookmarks for survey respondents who do not use Firefox as their primary browser*/

select avg(cast(left(events.data1,(position(' ' in events.data1))) as integer)) as avg_bookmarks
from events inner join survey
on events.user_id = survey.user_id
where events.event_code = 8 and (survey.q4 = '2' or survey.q4 = '3' or survey.q4 = '4' or survey.q4 = '5')
;

/*The average number of bookmarks for survey respondents who do not use Firefox as their primary browser is 208.5*/

/*What fraction of users created new bookmarks*/

select events.user_id, count(events.event_code)
from events inner join survey
on events.user_id = survey.user_id
where event_code = 9 and data1 = 'New Bookmark Added'
group by events.user_id
;

/*178 users out of 2282 created a new bookmark (removed new bookmark folder since this does not necessarily mean a new bookmark, which is 
recorded separately), which is 7.8%*/

/*What fraction of survey respondents who do use Firefox as their primary browser created new bookmarks*/

select events.user_id, count(events.event_code)
from events inner join survey
on events.user_id = survey.user_id
where event_code = 9 and data1 = 'New Bookmark Added' and (survey.q4 = '0' or survey.q4 = '1')
group by events.user_id
;

select events.user_id, count(events.event_code)
from events inner join survey
on events.user_id = survey.user_id
where (survey.q4 = '0' or survey.q4 = '1')
group by events.user_id
;

/*Removed new folder added. 156 out of 1917 primary users who had events recorded created a new bookmark, which is 8.1%*/

/*What fraction of survey respondents who do not use Firefox as their primary browser created new bookmarks*/

select events.user_id, count(events.event_code)
from events inner join survey
on events.user_id = survey.user_id
where (survey.q4 = '2' or survey.q4 = '3' or survey.q4 = '4' or survey.q4 = '5')
group by events.user_id
order by 1 asc
;

/*Removed new folder added. 10 out of 217 survey respondents who do not use Firefox as their primary browser, which is 4.6%*/

/*What fraction of users launched at least one bookmark during the sample week*/

select user_id, event_code, count(user_id)
from events
where event_code = 10
group by user_id, event_code
order by 1 asc
;

/*6534 users launched a bookmark during the sample week out of 27627 users, which is 23.7%*/

/*How many primary users launched a bookmark during the sample week*/

select events.user_id, events.event_code, count(events.user_id)
from events inner join survey
on events.user_id = survey.user_id
where events.event_code = 10 and (survey.q4 = '0' or survey.q4 = '1')
group by events.user_id, events.event_code
order by 1 asc
;


/*1001 of 3361 people who are primary users did, which is 29.8%*/

/*What fraction of survey respondents who do not use Firefox as their primary browser launched at least one bookmark during the sample week*/

select events.user_id, events.event_code, count(events.user_id)
from events inner join survey
on events.user_id = survey.user_id
where events.event_code = 10 and (survey.q4 = '2' or survey.q4 = '3' or survey.q4 = '4' or survey.q4 = '5')
group by events.user_id, events.event_code
;

/*77 users out of 440 survey respondents that do not use Firefox as their primary browser, which is 17.5%*/


/*What fraction of users had any interaction with bookmarks or bookmark folders (creating, launching, deleting)*/

select events.user_id, count(events.event_code) as bookmark_interactions
into temp bookmark_interactions
from events
where event_code = 9 or event_code = 10 or event_code = 11
group by events.user_id
order by 1 asc
;

/*6871 users out of 14718 with recorded events, which is 46.7%*/

/*What fraction of users who use Firefox as their primary browser had any interaction with bookmarks or bookmark folders*/

select events.user_id, count(events.event_code)
from events inner join survey
on events.user_id = survey.user_id
where (event_code = '9' or event_code = '10' or event_code = '11') and (survey.q4 = '0' or survey.q4 = '1')
group by events.user_id
order by 1 asc
;


select count(user_id)
from survey
where q4 = '0' or q4 = '1'
;

/*Of the 1917 people who said they use Firefox as their primary browser and were recorded in both the survey and events table, 1053 of them had an interaction with 
bookmarks or the bookmarks folder. This is 54.9%*/

/*What fraction of survey respondents who do not use Firefox as their primary browser had any interaction with bookmarks or bookmark folders (creating, launching, deleting)*/

select events.user_id, count(events.event_code)
from events inner join survey
on events.user_id = survey.user_id
where(event_code = 9 or event_code = 10 or event_code = 11) and  (survey.q4 = '2' or survey.q4 = '3' or survey.q4 = '4' or survey.q4 = '5')
group by events.user_id
order by 1 asc
;

/*82 out of 216 survey respondents who do not use Firefox as their primary browser and had events recorded on the events table, so 38%*/


/*3. Tabs*/

/*What is the average number of tabs each user had open*/

select user_id, avg(cast(left(events.data2,(position(' ' in events.data2))) as integer)) as average_tabs
into temp avg_tabs_all
from events
where event_code = '26'
group by user_id
order by 1 asc
;

/*Average number of tabs for primary Firefox users*/

select events.user_id, avg(cast(left(events.data2,(position(' ' in events.data2))) as integer)) as average_tabs
into temp avg_tabs_primary_firefox
from events inner join survey
on events.user_id = survey.user_id
where event_code = '26' and (survey.q4 = '0' or survey.q4 = '1')
group by events.user_id
order by 1 asc
;

select avg(cast(left(events.data2,(position(' ' in events.data2))) as integer)) as average_tabs
from events inner join survey
on events.user_id = survey.user_id
where event_code = '26' and (survey.q4 = '0' or survey.q4 = '1')
order by 1 asc
;

/*Primary Firefox users have 8 tabs open on average*/

/*Average number of tabs for non-primary users*/

select events.user_id, avg(cast(left(events.data2,(position(' ' in events.data2))) as integer)) as average_tabs
into temp avg_tabs_nonprimary_firefox
from events inner join survey
on events.user_id = survey.user_id
where event_code = '26' and (survey.q4 = '2' or survey.q4 = '3' or survey.q4 = '4' or survey.q4 = '5')
group by events.user_id
order by 1 asc
;

/*What percentage of all Firefox users with events recorded usually had more than 10 tabs open*/

select events.user_id, avg(cast(left(events.data2,(position(' ' in events.data2))) as integer)) as average_tabs
into temp avg_tabs_heavy_tabber
from events inner join survey
on events.user_id = survey.user_id
where event_code = '26'
group by events.user_id
having avg(cast(left(events.data2,(position(' ' in events.data2))) as integer))>10
order by 1 asc
;

/*223 out of 22718 - only about 1%*/

/*Primary Firefox users who usually have more than 10 tabs open*/

select events.user_id, avg(cast(left(events.data2,(position(' ' in events.data2))) as integer)) as average_tabs
from events inner join survey
on events.user_id = survey.user_id
where event_code = '26' and (survey.q4 = '0' or survey.q4 = '1')
group by events.user_id
having avg(cast(left(events.data2,(position(' ' in events.data2))) as integer))>10
order by 1 asc
;

/*196 primary Firefox users who usually have more than 10 tabs open out of 3361 primary Firefox users is 5.8%*/


/*Average number of tabs for non-primary Firefox users*/

select events.user_id, avg(cast(left(events.data2,(position(' ' in events.data2))) as integer)) as average_tabs
from events inner join survey
on events.user_id = survey.user_id
where event_code = '26' and (survey.q4 = '2' or survey.q4 = '3' or survey.q4 = '4' or survey.q4 = '5')
group by events.user_id
order by 1 asc
;

select avg(cast(left(events.data2,(position(' ' in events.data2))) as integer)) as average_tabs
from events inner join survey
on events.user_id = survey.user_id
where event_code = '26' and (survey.q4 = '2' or survey.q4 = '3' or survey.q4 = '4' or survey.q4 = '5')
order by 1 asc
;

/*On average, non-primary Firefox users have 9.3 tabs open WHICH IS MORE THAN PRIMARY FIREFOX USERS*/

/*Non-primary Firefox users who usually have more than 10 tabs open*/

select events.user_id, avg(cast(left(events.data2,(position(' ' in events.data2))) as integer)) as average_tabs
from events inner join survey
on events.user_id = survey.user_id
where event_code = '26' and (survey.q4 = '2' or survey.q4 = '3' or survey.q4 = '4' or survey.q4 = '5')
group by events.user_id
having avg(cast(left(events.data2,(position(' ' in events.data2))) as integer))>10
order by 1 asc
;

/*19 non-primary Firefox users who usually have more than 10 tabs open out of 440 non-primary Firefox users is 4.3%*/

/*Is there a correlation between lots of tabs and memory usage*/

select events.user_id, avg(cast(data2 as numeric))
from events
where (event_code = 19 and data2 <> '')
group by events.user_id
order by 1 asc
;

/*^Average memory usage for all users who had memory recorded*/

/*Average memory usage for all users who had their tabs recorded in the events table*/

select events.user_id, avg(cast(data2 as numeric)) as average_mem_use, avg_tabs_all.average_tabs
from events inner join avg_tabs_all
on events.user_id = avg_tabs_all.user_id
where (event_code = 19 and data2 <> '')
group by events.user_id, avg_tabs_all.average_tabs
;

select avg(cast(data2 as numeric))
from events inner join avg_tabs_all
on events.user_id = avg_tabs_all.user_id
where (event_code = 19 and data2 <> '')
;

	/*Average memory usage is 46541327.120839399878*/

/*Average memory usage for all users who average 10 or more tabs open at a time*/

select avg(cast(data2 as numeric))
from events inner join avg_tabs_heavy_tabber
on events.user_id = avg_tabs_heavy_tabber.user_id
where (event_code = 19 and data2 <> '')
;

	/*Average memory usage is 125454433.523720989870*/

/*Is there a correlation between having lots of bookmarks and memory usage*/

select events.user_id, bookmark_interactions.bookmark_interactions, avg(cast(events.data2 as numeric)) as average_mem_use
from events inner join bookmark_interactions
on events.user_id = bookmark_interactions.user_id
where events.event_code = 19 and events.data2 <> ''
group by events.user_id, bookmark_interactions.bookmark_interactions
;

/*Do non-primary Firefox users who use lots of tabs use lots of bookmarks too, or is it the opposite*/

select bookmark_interactions.user_id, bookmark_interactions.bookmark_interactions, avg_tabs_nonprimary_firefox.average_tabs
from bookmark_interactions inner join avg_tabs_nonprimary_firefox
on bookmark_interactions.user_id = avg_tabs_nonprimary_firefox.user_id
;


