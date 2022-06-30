---table1 charges charged by lake health alone
select [DRG Definition],[ Average Covered Charges ],[Average Medicare Payments]
from [hospital data]..[deseas&charges]

where [Provider Name]='LAKE HEALTH'
order by [Average Medicare Payments] desc

----table2 tatal pamenyts receved by hospitals

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



---table 3 avg paments per services


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


---table 4 min and max prices of services 

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

---table 5 no of people paken eack sevices


select [DRG Definition] as service_,sum([ Total Discharges ])  as number_of_people_taken_services
from [hospital data]..[deseas&charges]
group by [DRG Definition]
order by number_of_people_taken_services desc

--table6

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


---table7

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


--table 8
--total no of patents in each state or health status of state

with states_health_rank(state,total_patents)
as (
select [Provider State] as state,sum([ Total Discharges ]) as total_patents
from [hospital data]..[deseas&charges]
group by [Provider State]
)
select state,total_patents,ROW_NUMBER()over(order by total_patents) as health_rank
from states_health_rank
order by total_patents





