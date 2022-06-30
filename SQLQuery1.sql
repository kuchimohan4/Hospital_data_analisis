select *
from  [hospital data]..[deseas&charges] 


----

select *
from [hospital data]..[deseas&charges]

where [Provider Name]='LAKE HEALTH'


----


select *
from [hospital data]..[deseas&charges]

where [Provider Name] like 'LAKE%'

-----

--medical paments receved by each hospital



--select [Provider Name] as hospital,sum([ Total Discharges ]*cast([Average Medicare Payments] as float)) as total_medical_paments_receved
--from  [hospital data]..[deseas&charges] 
--group by [Provider Name]


with paments(hospital,avg_paments_receved,total_discharges)
as
(
select [Provider Name] as hospital,SUBSTRING([Average Medicare Payments],2,LEN([Average Medicare Payments])) as avg_paments_receved,[ Total Discharges ]
from  [hospital data]..[deseas&charges] 
)
select hospital,SUM(avg_paments_receved*total_discharges) as total_medical_paments
from  paments
group by hospital 
order by total_medical_paments desc


--for ordering data on paments receved
--with order_paments(hospital,total_paments_reved)
--as
--(
--with paments(hospital,avg_paments_receved,total_discharges)
--as
--(
--select [Provider Name] as hospital,SUBSTRING([Average Medicare Payments],2,LEN([Average Medicare Payments])) as avg_paments_receved,[ Total Discharges ]
--from  [hospital data]..[deseas&charges] 
--)
--select hospital,SUM(avg_paments_receved*total_discharges) 
--from  paments
--group by hospital
--)

--select * 
--from order_paments 
--order by total_paments_reved




-- avg  medicare paments chareged based on deasease


with paments(service_,avg_paments_receved)
as
(
select [DRG Definition] as service_,SUBSTRING([Average Medicare Payments],2,LEN([Average Medicare Payments])) as avg_paments_receved
from  [hospital data]..[deseas&charges] 
)
select service_,avg(cast(avg_paments_receved as float))  as avg_paments_for_service
from  paments
group by service_ 
order by avg_paments_for_service desc




--lowest treatment for deseases is avaliable in hospitals
with paments(service_,avg_paments_receved)
as
(
select [DRG Definition] as service_,SUBSTRING([Average Medicare Payments],2,LEN([Average Medicare Payments])) as avg_paments_receved
from  [hospital data]..[deseas&charges] 
)
select service_,min(cast(avg_paments_receved as float))  as min_paments_for_service,max(cast(avg_paments_receved as float))  as max_paments_for_service
from  paments
group by service_ 
order by min_paments_for_service



select *
from [hospital data]..[deseas&charges]


--number of people taking each service



select [DRG Definition] as service_,sum([ Total Discharges ])  as number_of_people_taken_services
from [hospital data]..[deseas&charges]
group by [DRG Definition]
order by number_of_people_taken_services desc



--hospital popularity based on no of patents



with cte(hospital,no_patents)
as (
select [Provider Name] as hospital,sum([ Total Discharges ]) as no_of_patents
from [hospital data]..[deseas&charges]
group by [Provider Name]

)
select hospital,no_patents,ROW_NUMBER() over (order by no_patents desc) as rank
from cte
order by no_patents desc 




---medical incme for hospitals according to states
with state_medical_income(state,medical_paments_receved)
as (
select [Provider State] as state,SUBSTRING([Average Medicare Payments],2,LEN([Average Medicare Payments])) as medical_paments_receved
from [hospital data]..[deseas&charges]
)
select state,sum(cast(medical_paments_receved as float)) as total_states_medical_incame
from state_medical_income
group by state
order by total_states_medical_incame desc


---
select * 
from [hospital data]..[deseas&charges]

----
--considaring we have all data of state
--total no of patents in each state or health status of state

select [Provider State] as state,sum([ Total Discharges ]) as total_patents
from [hospital data]..[deseas&charges]
group by [Provider State]
order by total_patents desc

--ranking
with states_health_rank(state,total_patents)
as (
select [Provider State] as state,sum([ Total Discharges ]) as total_patents
from [hospital data]..[deseas&charges]
group by [Provider State]
)
select state,total_patents,ROW_NUMBER()over(order by total_patents)
from states_health_rank
order by total_patents 


---adding total paments column

select *
from [hospital data]..[deseas&charges]
--
alter table [hospital data]..[deseas&charges]
add total_fee numeric

--
--update  [hospital data]..[deseas&charges]

--set total_fee =[Average Medicare Payments] + [ Average Covered Charges ]


---

with cte (medical_paments_receved,covered_paments_receved)
as (
select SUBSTRING([Average Medicare Payments],2,LEN([Average Medicare Payments])) as medical_paments_receved,SUBSTRING([ Average Covered Charges ],2,LEN([ Average Covered Charges ])) as covered_paments_receved
from [hospital data]..[deseas&charges]
)
select CAST(medical_paments_receved as float) + cast(covered_paments_receved as float) as total_fee
from cte

---
--update [hospital data]..[deseas&charges]
--set total_fee = (
--                 with cte (medical_paments_receved,covered_paments_receved)
--				 as (
--				 select SUBSTRING([Average Medicare Payments],2,LEN([Average Medicare Payments])) as medical_paments_receved,SUBSTRING([ Average Covered Charges ],2,LEN([ Average Covered Charges ])) as covered_paments_receved
--				 from [hospital data]..[deseas&charges]
--				 )
--				 select CAST(medical_paments_receved as float) + cast(covered_paments_receved as float) as total_fee
--				 from cte
--				 )

----
--update [hospital data]..[deseas&charges]
--set total_fee = with cte (medical_paments_receved,covered_paments_receved)
--as (
--select SUBSTRING([Average Medicare Payments],2,LEN([Average Medicare Payments])) as medical_paments_receved,SUBSTRING([ Average Covered Charges ],2,LEN([ Average Covered Charges ])) as covered_paments_receved
--from [hospital data]..[deseas&charges]
--)
--select CAST(medical_paments_receved as float) + cast(covered_paments_receved as float) as total_fee
--from cte

