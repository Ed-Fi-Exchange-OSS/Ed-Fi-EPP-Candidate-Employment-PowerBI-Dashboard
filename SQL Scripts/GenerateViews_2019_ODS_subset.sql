USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[ssaas]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[ssaas]
as


--    WITH SCHEMABINDING AS
select * from (
select 'ssa16' as TableYear
      ,[SchoolId]
      ,[StaffUSI]
	  ,AcademicSubjectDescriptorId
  FROM [EdFi_Ods_2016].[edfi].[StaffSchoolAssociationAcademicSubject] ssaas1
Union 
 SELECT 'ssa17' as TableYear 
      ,[SchoolId]
      ,[StaffUSI]
	  ,AcademicSubjectDescriptorId
  FROM EdFi_Ods_2017.edfi.StaffSchoolAssociationAcademicSubject ssaas2
Union
 SELECT 'ssa18' as TableYear 
      ,[SchoolId]
      ,[StaffUSI]
	  ,AcademicSubjectDescriptorId
  FROM EdFi_Ods_2018.edfi.StaffSchoolAssociationAcademicSubject ssaas3
Union
 SELECT 'ssa19' as TableYear 
      ,[SchoolId]
      ,[StaffUSI]
	  ,AcademicSubjectDescriptorId
  FROM EdFi_Ods_2019.edfi.StaffSchoolAssociationAcademicSubject ssaas4
) as ssaas_ALL
-- 3934 all of them for seoaa, seoea
-- 3650 all of them for ssa -- these stay static across the years as the schoolid and schoolyear change

--order by staffusi, TableYear

GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[seoaa]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE   VIEW [dbo].[seoaa]
as

--    WITH SCHEMABINDING AS


select * from (
select 'seoaa16' as TableYear
	   ,[BeginDate]
      ,[EducationOrganizationId]
      ,[StaffClassificationDescriptorId]
      ,[StaffUSI]
      ,[PositionTitle]
	  ,EndDate
  FROM [EdFi_Ods_2016].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa1
Union 
 SELECT 'seoaa17' as TableYear 
	  ,[BeginDate]
      ,[EducationOrganizationId]
      ,[StaffClassificationDescriptorId]
      ,[StaffUSI]
      ,[PositionTitle]
	  ,EndDate
  FROM EdFi_Ods_2017.edfi.StaffEducationOrganizationAssignmentAssociation seoaa2
Union
 SELECT 'seoaa18' as TableYear 
	  ,[BeginDate]
      ,[EducationOrganizationId]
      ,[StaffClassificationDescriptorId]
      ,[StaffUSI]
      ,[PositionTitle]
	  ,EndDate
  FROM EdFi_Ods_2018.edfi.StaffEducationOrganizationAssignmentAssociation seoaa3
Union
 SELECT 'seoaa19' as TableYear 
	  ,[BeginDate]
      ,[EducationOrganizationId]
      ,[StaffClassificationDescriptorId]
      ,[StaffUSI]
      ,[PositionTitle]
	  ,EndDate
  FROM EdFi_Ods_2019.edfi.StaffEducationOrganizationAssignmentAssociation seoaa4
) as seoaa_ALL
-- 3934 that is all of them
--
--where EndDate is not null
-- 284 records that are EndDate(d)
--
--where EndDate is null
-- 3650 records not EndDate(d)
--order by staffusi, TableYear

GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[SchoolAndDistrict]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- initial distributed to Tommy 3-26-2022
-- v1_1 modified to use 2019 database 5-23-2022


CREATE   VIEW [dbo].[SchoolAndDistrict]
as

select 
eoa.NameOfCounty as CountyName,
eo.EducationOrganizationId as DistrictNumber,
eo.NameOfInstitution as LEA_Name,	-- in SchoolAndDistrict as "FirstEmployedLEA"ciykd also be called District Name
d2.CodeValue as DistrctTYpe,
eoa.StreetNumberName as DistrictSiteStreetAddress,
eoa.City as DistrictSiteCity,
d1.CodeValue as DistrictSiteState
,eoa.PostalCode as DistrictSiteZip
,eo_sch.EducationOrganizationId as SchoolNumber
,eo_sch.NameOfInstitution as Campus
,eoa_sch.StreetNumberName as SchoolSiteStreetAddress
,eoa_sch.City as SchoolSiteCity
,eoa_sch.PostalCode as SchoolSiteZip
,eoa_sch.Latitude
,eoa_sch.Longitude
from EdFi_Ods_2019.edfi.EducationOrganization eo
inner join EdFi_Ods_2019.edfi.EducationOrganizationAddress eoa
on eo.EducationOrganizationId = eoa.EducationOrganizationId
inner join EdFi_Ods_2019.edfi.Descriptor d1
on eoa.StateAbbreviationDescriptorId = d1.DescriptorId
and d1.namespace like '%abbrev%'
and eo.Discriminator = 'edfi.LocalEducationAgency'
--and eo.Discriminator = 'edfi.School'
--
inner join 
EdFi_Ods_2019.edfi.School s
on s.LocalEducationAgencyId = eo.EducationOrganizationId
--396
inner join
EdFi_Ods_2019.edfi.EducationOrganization eo_sch
on s.SchoolId = eo_sch.EducationOrganizationId
--396
inner join EdFi_Ods_2019.edfi.EducationOrganizationAddress eoa_sch
on eoa_sch.EducationOrganizationId = s.SchoolId 
--396
inner join EdFi_Ods_2019.edfi.EducationOrganizationCategory eoc
on s.SchoolId = eoc.EducationOrganizationId
--396
inner join EdFi_Ods_2019.edfi.Descriptor d2
on eoc.EducationOrganizationCategoryDescriptorId = d2.DescriptorId
--396
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[RoleChanged_BeforeOnly]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- v1.0 created using the last modified query version 5-26-2022
--		remove the current year records - before only
--		still need to know min or max for TableYear??????

CREATE   VIEW [dbo].[RoleChanged_BeforeOnly]
as
-- modifed 5-26-2022 to add some comments 
-- and add another query that is similar to the Good Good, but has the prior record be the most recent ODS Year
-- before the change
-- the new query commented -- Good -- old is most recent before change -- Good put the before and the after together
--
--the StaffClassificationDescriptorId (ROLE) change has no end date
--since the records are NOT accumulating, will need to check prior ods
--------------------------------------------------------------------------------------------------------
-- Good Good only before ROLE
select 
	   min(tableyear) as TableYear,			-- get the oldest prior and group out dupes
	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
      ,PositionTitle
from EdFi_Ods_2019.dbo.seoaa seoaaALL
where seoaaALL.TableYear <> 'seoaa19'
and seoaaALL.StaffClassificationDescriptorId = 2205
and seoaaALL.staffusi in
(SELECT StaffUSI
FROM [EdFi_Ods_2019].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa19
where seoaa19.StaffClassificationDescriptorId <> 2205 
) -- 222 from the prior years
group by 	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
      ,PositionTitle
--order by StaffUSI, TableYear desc
-- 444 with the current year records and the oldest prior year records that match on USI
--------------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[LocationChanged_BeforeOnly]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- v1.0 created using the last modified query version 5-26-2022
--		qualify with EndDate NULL to pull the record before it was EndDate(d)
--		Will not need to know table year because we have the EndDate
--		Do I need to query out the before school year, using the EndDate???
--		Would I need to do this after the ODS year change????

CREATE   VIEW [dbo].[LocationChanged_BeforeOnly]
as

-----------------------------------------------------------------------------------------------------
-- Good Good only before  LOCATION
select * from [EdFi_Ods_2019].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa19
where exists 
(select 1 from [EdFi_Ods_2019].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaaxx
where seoaa19.staffusi = seoaaxx.staffusi
and EndDate is not null)
and seoaa19.EndDate is null
--order by StaffUSI,BeginDate
-- 304 records with the before and after EdOrg
-----------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[2019_LocationChanged_Only]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--9-5-2022 drop the XT suffix and just rename existing view to x...
-- v1.0 7-31-2022

CREATE   VIEW [dbo].[2019_LocationChanged_Only]
as

-----------------------------------------------------------------------------------------------------
-- Good Good before and after LOCATION
select
case when EndDate is null then 'CurrentYear'
	 when EndDate is not null then 'Prior Year'
end as TableYear,
	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
	  ,PositionTitle
      ,EndDate
	  ,EmploymentEducationOrganizationId
	  ,2019 as ChangeYear 
from [EdFi_Ods_2019].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa19
where exists 
(select 1 from [EdFi_Ods_2019].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaaxx
where seoaa19.staffusi = seoaaxx.staffusi
and EndDate is not null
)
and seoaa19.StaffUSI not in (
select StaffUSI from EdFi_Ods_2017.edfi.StaffEducationOrganizationAssignmentAssociation seoaa17
where not exists
(select 1 from EdFi_Ods_2018.edfi.StaffEducationOrganizationAssignmentAssociation seoaa18
where seoaa17.StaffUSI = seoaa18.StaffUSI)
)
--and not exists (select 1 from tpdm.dbo.[2017ListForDisappear] lfd17 where seoaa19.staffusi = lfd17.staffusi)  
and seoaa19.StaffUSI not in (
select StaffUSI from EdFi_Ods_2018.edfi.StaffEducationOrganizationAssignmentAssociation seoaa18
where not exists
(select 1 from EdFi_Ods_2019.edfi.StaffEducationOrganizationAssignmentAssociation seoaa19
where seoaa18.StaffUSI = seoaa19.StaffUSI)
)
--and not exists (select 1 from tpdm.dbo.[2018ListForDisappear] lfd18 where seoaa19.staffusi = lfd18.staffusi)  
and seoaa19.staffusi not in (
select StaffUSI from [EdFi_Ods_2017].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa17
where not exists (select 1 from [EdFi_Ods_2016].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa16
where seoaa16.StaffUSI = seoaa17.StaffUSI
and seoaa16.EducationOrganizationId = seoaa17.EducationOrganizationId
)
and seoaa17.staffusi in (select StaffUSI from EdFi_Ods_2016.edfi.StaffEducationOrganizationAssignmentAssociation)
)
--and not exists (select 1 from tpdm.dbo.[2016ListForLocation] lfl16 
--where lfl16.[Column 6] > ' ' and
--seoaa19.staffusi = lfl16.staffusi)  
and seoaa19.staffusi not in (
select StaffUSI from [EdFi_Ods_2018].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa18
where not exists (select 1 from [EdFi_Ods_2017].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa17
where seoaa17.StaffUSI = seoaa18.StaffUSI
and seoaa17.EducationOrganizationId = seoaa18.EducationOrganizationId
)
and seoaa18.staffusi in (select StaffUSI from EdFi_Ods_2017.edfi.StaffEducationOrganizationAssignmentAssociation)
)
--and not exists (select 1 from tpdm.dbo.[2017ListForLocation] lfl17 
--where lfl17.type > ' ' and
--seoaa19.staffusi = lfl17.staffusi)  
and seoaa19.EndDate is NULL
--order by StaffUSI,EndDate
-- 104	2017
--  56	2018
-- 144	2019
-- 304 records with the before and after EdOrg
-----------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[2018_LocationChanged_Only]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--9-5-2022 drop the XT suffix and just rename existing view to x...
-- v1.0 7-30-2022

CREATE   VIEW [dbo].[2018_LocationChanged_Only]
as

-----------------------------------------------------------------------------------------------------
-- Good Good before and after LOCATION
select 
case when EndDate is null then 'CurrentYear'
	 when EndDate is not null then 'Prior Year'
end as TableYear,
	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
	  ,PositionTitle
      ,EndDate
	  ,EmploymentEducationOrganizationId
	  ,2018 as ChangeYear 
from [EdFi_Ods_2018].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa18 -- where staffusi = 5501
where exists 
(select 1 from [EdFi_Ods_2018].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaaxx
where seoaa18.staffusi = seoaaxx.staffusi
and EndDate is not null
)
and seoaa18.StaffUSI not in (
select StaffUSI from EdFi_Ods_2017.edfi.StaffEducationOrganizationAssignmentAssociation seoaa17
where not exists
(select 1 from EdFi_Ods_2018.edfi.StaffEducationOrganizationAssignmentAssociation seoaa18
where seoaa17.StaffUSI = seoaa18.StaffUSI)
)
and seoaa18.staffusi not in (
select StaffUSI from EdFi_Ods_2018.edfi.StaffEducationOrganizationAssignmentAssociation seoaa18
where not exists
(select 1 from EdFi_Ods_2019.edfi.StaffEducationOrganizationAssignmentAssociation seoaa19
where seoaa18.StaffUSI = seoaa19.StaffUSI)
)
and seoaa18.staffusi not in (
select StaffUSI from [EdFi_Ods_2017].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa17
where not exists (select 1 from [EdFi_Ods_2016].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa16
where seoaa16.StaffUSI = seoaa17.StaffUSI
and seoaa16.EducationOrganizationId = seoaa17.EducationOrganizationId
)
and seoaa17.staffusi in (select StaffUSI from EdFi_Ods_2016.edfi.StaffEducationOrganizationAssignmentAssociation)
)
and seoaa18.EndDate is NULL

-- 56 
--order by StaffUSI
-- 104	2017
--  56	2018
-- 144	2019
-- 304 records with the before and after EdOrg
-----------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[2017_LocationChanged_Only]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--9-5-2022 drop the XT suffix and just rename existing view to x...
-- v1.0 7-30-2022

CREATE   VIEW [dbo].[2017_LocationChanged_Only]
as

-----------------------------------------------------------------------------------------------------
-- Good Good before and after LOCATION
select 'CurrentYear' as TableYear,
	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
	  ,PositionTitle
      ,EndDate
	  ,EmploymentEducationOrganizationId
	  ,2017 as ChangeYear 
from [EdFi_Ods_2017].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa17
where exists 
(select 1 from [EdFi_Ods_2017].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaaxx
where seoaa17.staffusi = seoaaxx.staffusi
and EndDate is not null
--and substring(cast(enddate as varchar(16)),1,4) in ('2016','2017') -- NO HELP these years don't match school years
)
and seoaa17.StaffUSI not in 
-- below are records that existed in 2017 but not 2018 - same as view "2017_LocationChanged_BeforeAfter"
(select StaffUSI from EdFi_Ods_2017.edfi.StaffEducationOrganizationAssignmentAssociation seoaa17
where not exists
(select 1 from EdFi_Ods_2018.edfi.StaffEducationOrganizationAssignmentAssociation seoaa18
where seoaa17.StaffUSI = seoaa18.StaffUSI))  
-- 104
and seoaa17.EndDate is NULL
-- 52
--order by seoaa17.staffusi,seoaa17.EndDate

--order by EndDate,StaffUSI
--order by StaffUSI,BeginDate

-- 104	2017
--  56	2018
-- 144	2019
-- 304 records with the before and after EdOrg
-----------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[SubjectChanged_BeforeOnly]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- v1.0 created using the last modified query version 5-26-2022
--		remove the current year records - before only
--		still need to know min or max for TableYear??????

CREATE   VIEW [dbo].[SubjectChanged_BeforeOnly]
as
-- Good Good only before SUBJECT
select 
	   min(tableyear) as TableYear,				-- get the oldest prior and group out dupes
[AcademicSubjectDescriptorId]
      ,[SchoolId]
      ,[StaffUSI]
from EdFi_Ods_2019.dbo.ssaas  ssaaALL
  where exists 
  (select 1 from EdFi_Ods_2019.edfi.StaffSchoolAssociationAcademicSubject ssaas
  where ssaas.StaffUSI = ssaaALL.StaffUSI
  and ssaas.AcademicSubjectDescriptorId <> ssaaALL.AcademicSubjectDescriptorId)
group by
[AcademicSubjectDescriptorId]
      ,[SchoolId]
      ,[StaffUSI]
-- 280
--order by StaffUSI, TableYear desc
------------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[CandidateView]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- initial distributed to Tommy 3-26-2022
-- v1_0 corrected CertYear to be derrived from CredentialEventDate instead of HireDate
-- v1_1 modified to use correct tables and 2019 database 5-23-2022

CREATE   VIEW [dbo].[CandidateView]
as

select 
seoaa.StaffUSI,
c.CandidateIdentifier,c.FirstName,c.LastSurname,c.SexDescriptorId,cr.RaceDescriptorId
,case when c.HispanicLatinoEthnicity = 1 then 'True' else 'False' end as HispanicLatinoEthnicity
,case when EconomicDisadvantaged = 1 then 'True' else '' end as EcononicDisadvantaged
,ccy.SchoolYear as Cohort
,case c.ProgramComplete	when 1 then 'True' else 'False' end as ProgramComplete							
--no--,StudentUSI			-- not using
,ceppa.ProgramName
--,cev.CredentialEventDate as BeginDate
,seoaa.BeginDate as EmploymentBeginDate
,ceppa.EducationOrganizationId
,c.PersonId,cred.IssuanceDate,
case when cev.CredentialEventDate > ' ' then 'true' else 'false' end as Credentialed,
cev.CredentialEventDate as [Certification Date],
--d6.CodeValue as CredentialType,			-- CredentialTypeDescriptor IS THIS USED ANYWHERE CONFUSING NAME
d7.CodeValue as CertificationType,
--no--cred.CredentialIdentifier,ceppa.EducationOrganizationId as [Campus ID],
seoaa.EducationOrganizationId as [Campus ID],
cast(case 
when SUBSTRING(cast(credentialeventdate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(credentialeventdate as varchar(10)),1,4) 
when SUBSTRING(cast(credentialeventdate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(credentialeventdate as varchar(10)),1,4)-1 end as int) as CertificationYear,
c.FirstName+' '+C.LastSurname as [Candidate Name],
d8.CodeValue as CertificationGradeLevel,
d9.CodeValue as CertificationSubjectArea, 
da.CodeValue as TeachingSubjectArea,
case isnull(seoaa.EndDate,'') when '' then 'Employed' else 'UnEmployed' end as Employed,
case when cred.EffectiveDate > '' then 'Certified' else '' end as Cerfified
-- EPP
,db.CodeValue as Position
,seoea.HireDate
,cast(case 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(HireDate as varchar(10)),1,4) 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(HireDate as varchar(10)),1,4)-1 end as varchar(11)) 
+'-'+
cast(
cast(case 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(HireDate as varchar(10)),1,4) 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(HireDate as varchar(10)),1,4)-1 end as int)+1 as varchar(11))
as BeginYear
,d1.codevalue as Race
,d2.codevalue as Sex
,cast(case 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4) 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4)-1 end as varchar(11)) 
+'-'+
cast(
cast(case 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4) 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4)-1 end as int)+1 as varchar(11))
as CertYear

-- 1289
-- after remove some garbled have 1277 rows 3-17-2022
--cred.*,
--credx.*,
--cev.*,
--cred.EffectiveDate,						-- Credential
--epp.*,
--,ccy.SchoolYear as Cohort,				-- CandidateCohortYear
--cev.CredentialEventDate,
--d7.codevalue,
--d6.CodeValue as CredentialType,			-- CredentialTypeDescriptor
--d5.CodeValue as CredentialStateOfIssue,	-- Credential StateOfIssueStateAbbreviationDescriptor
--d4.CodeValue as CredentialField,		-- CredentialField Descriptor -- only a subset are populated	
--c.CandidateIdentifier,c.FirstName,c.LastSurname
--,c.SexDescriptorId,d2.codevalue as Sex
--,cr.RaceDescriptorId,d1.CodeValue as 'Race' ,c.BirthDate
--,c.HispanicLatinoEthnicity,EconomicDisadvantaged,ProgramComplete
--,c.SourceSystemDescriptorId,d3.CodeValue as 'Source System'
--,c.EducationOrganizationId  
--select * 
from EdFi_Ods_2019.tpdm.Candidate c									-- 1 94 rows with Campus ID also in EdOrg as a district
inner join EdFi_Ods_2019.tpdm.CandidateRace cr						-- 2 94
on c.CandidateIdentifier = cr.CandidateIdentifier

inner join EdFi_Ods_2019.edfi.Descriptor d1							-- 3 94
on cr.RaceDescriptorId = d1.DescriptorId
and d1.namespace = 'uri://ed-fi.org/RaceDescriptor'

inner join EdFi_Ods_2019.edfi.SexDescriptor sd						-- 4 94
on c.SexDescriptorId = sd.SexDescriptorId
inner join EdFi_Ods_2019.edfi.Descriptor d2
on sd.SexDescriptorId = d2.DescriptorId

inner join EdFi_Ods_2019.edfi.SourceSystemDescriptor ssd			-- 5 94
on c.SourceSystemDescriptorId = ssd.SourceSystemDescriptorId
inner join EdFi_Ods_2019.edfi.Descriptor d3
on ssd.SourceSystemDescriptorId = d3.DescriptorId

inner join EdFi_Ods_2019.tpdm.credentialextension credx				-- 6 108
on c.PersonId = credx.personid 

inner join EdFi_Ods_2019.edfi.Credential cred						-- 7 108
on cred.CredentialIdentifier = credx.CredentialIdentifier

inner join EdFi_Ods_2019.tpdm.CredentialEvent cev					-- 8 108
on cred.EffectiveDate = cev.CredentialEventDate 
and cred.CredentialIdentifier = cev.CredentialIdentifier
and cred.StateOfIssueStateAbbreviationDescriptorId = cev.StateOfIssueStateAbbreviationDescriptorId

left join EdFi_Ods_2019.edfi.Descriptor d4							--  108
on cred.CredentialFieldDescriptorId = d4.DescriptorId

inner join EdFi_Ods_2019.edfi.Descriptor d5							--  108
on cred.StateOfIssueStateAbbreviationDescriptorId = d5.DescriptorId

inner join EdFi_Ods_2019.edfi.Descriptor d6							--  108
on cred.CredentialTypeDescriptorId = d6.DescriptorId
and d6.Namespace like '%credentialtype%'

inner join EdFi_Ods_2019.edfi.Descriptor d7
on cred.TeachingCredentialDescriptorId = d7.DescriptorId
and d7.Namespace = 'uri://ed-fi.org/TeachingCredentialDescriptor'

inner join EdFi_Ods_2019.edfi.CredentialGradeLevel cgl
on cred.CredentialIdentifier = cgl.CredentialIdentifier
inner join EdFi_Ods_2019.edfi.Descriptor d8
on cgl.GradeLevelDescriptorId = d8.DescriptorId

inner join EdFi_Ods_2019.edfi.CredentialAcademicSubject cas
on cred.CredentialIdentifier = cas.CredentialIdentifier
inner join EdFi_Ods_2019.edfi.Descriptor d9
on cas.AcademicSubjectDescriptorId = d9.DescriptorId

inner join EdFi_Ods_2019.tpdm.CandidateCohortYear ccy				-- 12 108
on ccy.CandidateIdentifier = c.CandidateIdentifier
-- 108
  
inner join EdFi_Ods_2019.tpdm.CandidateEducatorPreparationProgramAssociation ceppa	-- 13 108
on c.candidateidentifier = ceppa.candidateidentifier
  --and c.EducationOrganizationId = ceppa.EducationOrganizationId
  -- 108 rows 3-18-2022

inner join EdFi_Ods_2019.tpdm.EducatorPreparationProgram epp		-- 14 136
on epp.ProgramName = ceppa.ProgramName
and epp.ProgramTypeDescriptorId = ceppa.ProgramTypeDescriptorId
and epp.EducationOrganizationId = ceppa.EducationOrganizationId
--and epp.EducationOrganizationId = ceppa.EducationOrganizationId

inner join EdFi_Ods_2019.edfi.staff s								-- 15 136
on c.PersonId = s.PersonId

inner join EdFi_Ods_2019.edfi.EducationOrganization eo				-- 16 136
on ceppa.EducationOrganizationId = eo.EducationOrganizationId

inner join EdFi_Ods_2019.edfi.EducationOrganizationAddress eoa		-- 17 136
on eo.EducationOrganizationId = eoa.EducationOrganizationId

inner join EdFi_Ods_2019.edfi.StaffSchoolAssociation ssa
on s.staffusi = ssa.StaffUSI 
-- 136 rows

inner join EdFi_Ods_2019.edfi.StaffSchoolAssociationAcademicSubject ssaas
on ssa.staffusi = ssaas.StaffUSI 
--no--and ssa.SchoolId = ssaas.SchoolId				-- would like to get by without using the ssa schoolid -- may null
and ssa.ProgramAssignmentDescriptorId = ssaas.ProgramAssignmentDescriptorId
-- 136 rows

inner join EdFi_Ods_2019.edfi.Descriptor da
on ssaas.AcademicSubjectDescriptorId = da.DescriptorId
--136 rows

inner join EdFi_Ods_2019.edfi.StaffEducationOrganizationAssignmentAssociation seoaa
on ssaas.StaffUSI = seoaa.StaffUSI
and ssaas.SchoolId = seoaa.EducationOrganizationId
-- 136
inner join EdFi_Ods_2019.edfi.Descriptor db
on seoaa.StaffClassificationDescriptorId = db.DescriptorId
--136
inner join EdFi_Ods_2019.edfi.StaffEducationOrganizationEmploymentAssociation seoea
on seoaa.StaffUSI = seoea.StaffUSI
and seoaa.EducationOrganizationId = seoea.EducationOrganizationId
and seoaa.BeginDate = seoea.HireDate
--136
--x-left join EdFi_Ods_2019.edfi.student stu	-- do not need student
--x-on c.PersonId = stu.PersonId
-- 136 rows

where seoaa.EndDate is null and seoea.EndDate is null
--order by StaffUSI
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[2019_SubjectChanged_Only]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- v1.0 created 7-27-2022

CREATE   VIEW [dbo].[2019_SubjectChanged_Only]
as
SELECT 
'CurrentYear' as TableYear,
[AcademicSubjectDescriptorId]
      ,[SchoolId]
      ,[StaffUSI]
	  ,2019 as ChangeYear
  FROM [EdFi_Ods_2019].[edfi].[StaffSchoolAssociationAcademicSubject] ssaas
  where exists 
  (select 1 from EdFi_Ods_2019.dbo.ssaas  ssaaALL
  where ssaas.StaffUSI = ssaaALL.StaffUSI
  and ssaas.AcademicSubjectDescriptorId <> ssaaALL.AcademicSubjectDescriptorId
  and ssaaALL.TableYear = 'ssa18'
  )
-- 69*2 = 138				-- change in 2017
-- 44*2 = 88				-- change in 2018
-- 27*2 = 54				-- change in 2019
-----
-- 140	  280
--order by StaffUSI, TableYear desc
------------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[2019_SubjectChanged_BeforeAfter]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- v1.0 created 7-27-2022

CREATE   VIEW [dbo].[2019_SubjectChanged_BeforeAfter]
as
SELECT 
'CurrentYear' as TableYear,
[AcademicSubjectDescriptorId]
      ,[SchoolId]
      ,[StaffUSI]
	  ,2019 as ChangeYear
  FROM [EdFi_Ods_2019].[edfi].[StaffSchoolAssociationAcademicSubject] ssaas
  where exists 
  (select 1 from EdFi_Ods_2019.dbo.ssaas  ssaaALL
  where ssaas.StaffUSI = ssaaALL.StaffUSI
  and ssaas.AcademicSubjectDescriptorId <> ssaaALL.AcademicSubjectDescriptorId
  and ssaaALL.TableYear = 'ssa18'
  )
-- 69*2 = 138				-- change in 2017
-- 44*2 = 88				-- change in 2018
-- 27*2 = 54				-- change in 2019
-----
-- 140	  280
union
select 
	   min(tableyear) as TableYear,					-- get the oldest prior and group out dupes
[AcademicSubjectDescriptorId]
      ,[SchoolId]
      ,[StaffUSI]
	  ,2019 as ChangeYear
from EdFi_Ods_2019.dbo.ssaas  ssaaALL
  where exists 
  (select 1 from EdFi_Ods_2019.edfi.StaffSchoolAssociationAcademicSubject ssaas
  where ssaas.StaffUSI = ssaaALL.StaffUSI
  and ssaas.AcademicSubjectDescriptorId <> ssaaALL.AcademicSubjectDescriptorId)
  and ssaaALL.TableYear = 'ssa18'
group by
[AcademicSubjectDescriptorId]
      ,[SchoolId]
      ,[StaffUSI]
--order by StaffUSI, TableYear desc
------------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[2019_RoleChanged_Only]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- v1.0 created 7-24-2022

CREATE   VIEW [dbo].[2019_RoleChanged_Only]
as
-- 7-23-2022 cloned from RoleChanged_BeforeAfter and made Year over Year specific 
-- modifed 5-26-2022 to add some comments 
-- and add another query that is similar to the Good Good, but has the prior record be the most recent ODS Year
-- before the change
-- the new query commented -- Good -- old is most recent before change -- Good put the before and the after together
--
--the StaffClassificationDescriptorId (ROLE) change has no end date
--since the records are NOT accumulating, will need to check prior ods
--------------------------------------------------------------------------------------------------------
-- Good Good put the before and the after together
SELECT 'CurrentYear' as TableYear,
	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
      ,PositionTitle
	  ,2019 as ChangeYear
FROM [EdFi_Ods_2019].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa19
where seoaa19.StaffClassificationDescriptorId <> 2205
and staffusi in (select staffusi from  EdFi_Ods_2019.dbo.seoaa where TableYear = 'seoaa18'
and seoaa.StaffClassificationDescriptorId = 2205)
--  52	2017
--  46	2018
-- 124	2019
-- 222 changed in all years
--------------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[2019_NoChangeRoles_WITH_COHORT]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- v1.0 created 7-28-2022

CREATE   VIEW [dbo].[2019_NoChangeRoles_WITH_COHORT]
as
-- 7-23-2022 cloned from RoleChanged_BeforeAfter and made Year over Year specific 
-- modifed 5-26-2022 to add some comments 
-- and add another query that is similar to the Good Good, but has the prior record be the most recent ODS Year
-- before the change
-- the new query commented -- Good -- old is most recent before change -- Good put the before and the after together
--
--the StaffClassificationDescriptorId (ROLE) change has no end date
--since the records are NOT accumulating, will need to check prior ods
--------------------------------------------------------------------------------------------------------
-- Good Good put the before and the after together
SELECT 'CurrentYear' as TableYear,
	   BeginDate
      ,seoaa19.EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,seoaa19.StaffUSI
      ,PositionTitle
	  ,2019 as ChangeYear
	  ,ccy.SchoolYear as CertYear
FROM [EdFi_Ods_2019].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa19
inner join EdFi_Ods_2019.edfi.staff s
on seoaa19.StaffUSI = s.StaffUSI
inner join EdFi_Ods_2019.tpdm.Candidate c
on s.PersonId = c.PersonId
inner join EdFi_Ods_2019.tpdm.CandidateCohortYear ccy
on c.CandidateIdentifier = ccy.CandidateIdentifier

-- 1316
-- 1192
------
--  124
where
--staffusi not in (select staffusi from tpdm.dbo.[2017ListForDisappear])	-- these already deleted from 2018 and 2019
--and																		-- just uncommented these to test and then recomment
--staffusi not in (select staffusi from tpdm.dbo.[2018ListForDisappear])
--and
seoaa19.staffusi not in (
select distinct staffusi from (



SELECT 'CurrentYear' as TableYear,
	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
      ,PositionTitle
	  ,2019 as ChangeYear
FROM [EdFi_Ods_2019].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa19
where seoaa19.StaffClassificationDescriptorId <> 2205
and staffusi in (select staffusi from  EdFi_Ods_2019.dbo.seoaa where TableYear = 'seoaa18'
and seoaa.StaffClassificationDescriptorId = 2205)
--  52	2017
--  46	2018
-- 124	2019
-- 222 changed in all years
union
select 
	   min(tableyear) as TableYear,			-- get the oldest prior and group out dupes
	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
      ,PositionTitle
	  ,2019 as ChangeYear
from EdFi_Ods_2019.dbo.seoaa seoaaALL
where seoaaALL.TableYear = 'seoaa18'
and seoaaALL.StaffClassificationDescriptorId = 2205
and seoaaALL.staffusi in
(SELECT StaffUSI
FROM [EdFi_Ods_2019].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa19
where seoaa19.StaffClassificationDescriptorId <> 2205 
) -- 222 from the prior years
group by 	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
      ,PositionTitle
) as yy
)
--order by StaffUSI, TableYear desc
-- 104	2017
--  92	2018
-- 248	2019
-- 444 with the current year records and the oldest prior year records that match on USI
--------------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[2018_SubjectChanged_Only]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- v1.0 created 7-27-2022

CREATE   VIEW [dbo].[2018_SubjectChanged_Only]
as
SELECT 
'CurrentYear' as TableYear,
[AcademicSubjectDescriptorId]
      ,[SchoolId]
      ,[StaffUSI]
	  ,2018 as ChangeYear
  FROM [EdFi_Ods_2018].[edfi].[StaffSchoolAssociationAcademicSubject] ssaas
  where exists 
  (select 1 from EdFi_Ods_2019.dbo.ssaas  ssaaALL
  where ssaas.StaffUSI = ssaaALL.StaffUSI
  and ssaas.AcademicSubjectDescriptorId <> ssaaALL.AcademicSubjectDescriptorId
  and ssaaALL.TableYear = 'ssa17'
  )
-- 69*2 = 138				-- change in 2017
-- 44*2 = 88				-- change in 2018
-- 27*2 = 54				-- change in 2019
-----
-- 140	  280 
--order by StaffUSI, TableYear desc
------------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[2018_SubjectChanged_BeforeAfter]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- v1.0 created 7-27-2022

CREATE   VIEW [dbo].[2018_SubjectChanged_BeforeAfter]
as
SELECT 
'CurrentYear' as TableYear,
[AcademicSubjectDescriptorId]
      ,[SchoolId]
      ,[StaffUSI]
	  ,2018 as ChangeYear
  FROM [EdFi_Ods_2018].[edfi].[StaffSchoolAssociationAcademicSubject] ssaas
  where exists 
  (select 1 from EdFi_Ods_2019.dbo.ssaas  ssaaALL
  where ssaas.StaffUSI = ssaaALL.StaffUSI
  and ssaas.AcademicSubjectDescriptorId <> ssaaALL.AcademicSubjectDescriptorId
  and ssaaALL.TableYear = 'ssa17'
  )
-- 69*2 = 138				-- change in 2017
-- 44*2 = 88				-- change in 2018
-- 27*2 = 54				-- change in 2019
-----
-- 140	  280 
union

select 
TableYear,
[AcademicSubjectDescriptorId]
      ,[SchoolId]
      ,[StaffUSI]
	  ,2018 as ChangeYear
from EdFi_Ods_2019.dbo.ssaas  ssaaALL
where TableYear = 'ssa17'
and exists 
(select 1 from EdFi_Ods_2019.dbo.ssaas next where tableyear = 'ssa18'
and ssaaALL.StaffUSI = next.staffusi
and next.AcademicSubjectDescriptorId <> ssaaALL.AcademicSubjectDescriptorId
)
--order by StaffUSI, TableYear desc
------------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[2018_RoleChanged_Only]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- v1.0 created 7-24-2022

CREATE   VIEW [dbo].[2018_RoleChanged_Only]
as
-- 7-23-2022 cloned from RoleChanged_BeforeAfter and made Year over Year specific 
-- modifed 5-26-2022 to add some comments 
-- and add another query that is similar to the Good Good, but has the prior record be the most recent ODS Year
-- before the change
-- the new query commented -- Good -- old is most recent before change -- Good put the before and the after together
--
--the StaffClassificationDescriptorId (ROLE) change has no end date
--since the records are NOT accumulating, will need to check prior ods
--------------------------------------------------------------------------------------------------------
-- Good Good put the before and the after together
SELECT 'CurrentYear' as TableYear,
	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
      ,PositionTitle
	  ,2018 as ChangeYear
FROM [EdFi_Ods_2018].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa18
where seoaa18.StaffClassificationDescriptorId <> 2205
and staffusi in (select staffusi from  EdFi_Ods_2019.dbo.seoaa where TableYear = 'seoaa17'
and seoaa.StaffClassificationDescriptorId = 2205)
--  52	2017
--  46	2018
-- 124	2019
-------------
-- 222 changed in all years
--------------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[2018_NoChangeRoles_WITH_COHORT]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- v1.0 created 7-28-2022

CREATE   VIEW [dbo].[2018_NoChangeRoles_WITH_COHORT]
as
-- 7-23-2022 cloned from RoleChanged_BeforeAfter and made Year over Year specific 
-- modifed 5-26-2022 to add some comments 
-- and add another query that is similar to the Good Good, but has the prior record be the most recent ODS Year
-- before the change
-- the new query commented -- Good -- old is most recent before change -- Good put the before and the after together
--
--the StaffClassificationDescriptorId (ROLE) change has no end date
--since the records are NOT accumulating, will need to check prior ods
--------------------------------------------------------------------------------------------------------
-- Good Good put the before and the after together
SELECT 'CurrentYear' as TableYear,
	   BeginDate
      ,seoaa18.EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,seoaa18.StaffUSI
      ,PositionTitle
	  ,2018 as ChangeYear
	  ,ccy.SchoolYear as CertYear
FROM [EdFi_Ods_2018].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa18
inner join EdFi_Ods_2018.edfi.staff s
on seoaa18.StaffUSI = s.StaffUSI
inner join EdFi_Ods_2018.tpdm.Candidate c
on s.PersonId = c.PersonId
inner join EdFi_Ods_2018.tpdm.CandidateCohortYear ccy
on c.CandidateIdentifier = ccy.CandidateIdentifier

-- 1142
-- 1096
------
--   46
where
--staffusi not in (select staffusi from tpdm.dbo.[2017ListForDisappear])	-- these already deleted from 2018 and 2019
--and																		-- just uncommented these to test and then recomment
seoaa18.StaffUSI not in (
select distinct staffusi from (

SELECT 'CurrentYear' as TableYear,
	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
      ,PositionTitle
	  ,2018 as ChangeYear
FROM [EdFi_Ods_2018].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa18
where seoaa18.StaffClassificationDescriptorId <> 2205
and staffusi in (select staffusi from  EdFi_Ods_2019.dbo.seoaa where TableYear = 'seoaa17'
and seoaa.StaffClassificationDescriptorId = 2205)
--  52	2017
--  46	2018
-- 124	2019
-------------
-- 222 changed in all years
union
select 
	   min(tableyear) as TableYear,			-- get the oldest prior and group out dupes
	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
      ,PositionTitle
	  ,2018 as ChangeYear
from EdFi_Ods_2019.dbo.seoaa seoaaALL
where seoaaALL.TableYear = 'seoaa17'
and seoaaALL.StaffClassificationDescriptorId = 2205
and seoaaALL.staffusi in
(SELECT StaffUSI
FROM [EdFi_Ods_2018].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa18
where seoaa18.StaffClassificationDescriptorId <> 2205 
) -- 222 from the prior years
group by 	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
      ,PositionTitle
) as yy
)
--order by StaffUSI, TableYear desc
-- 104	2017
--  92	2018
-- 248	2019
-- 444	with the current year records and the oldest prior year records that match on USI
--------------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[2017_SubjectChanged_Only]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- v1.0 created 7-27-2022

CREATE   VIEW [dbo].[2017_SubjectChanged_Only]
as
SELECT 
'CurrentYear' as TableYear,
[AcademicSubjectDescriptorId]
      ,[SchoolId]
      ,[StaffUSI]
	  ,2017 as ChangeYear
  FROM [EdFi_Ods_2017].[edfi].[StaffSchoolAssociationAcademicSubject] ssaas
  where exists 
  (select 1 from EdFi_Ods_2019.dbo.ssaas  ssaaALL
  where ssaas.StaffUSI = ssaaALL.StaffUSI
  and ssaas.AcademicSubjectDescriptorId <> ssaaALL.AcademicSubjectDescriptorId
  and ssaaALL.TableYear = 'ssa16'
  )
-- 69*2 = 138				-- change in 2017
-- 44*2 = 88				-- change in 2018
-- 27*2 = 54				-- change in 2019
-----
-- 140	  280
--order by StaffUSI, TableYear desc
------------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[2017_SubjectChanged_BeforeAfter]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- v1.0 created 7-27-2022

CREATE   VIEW [dbo].[2017_SubjectChanged_BeforeAfter]
as
SELECT 
'CurrentYear' as TableYear,
[AcademicSubjectDescriptorId]
      ,[SchoolId]
      ,[StaffUSI]
	  ,2017 as ChangeYear
  FROM [EdFi_Ods_2017].[edfi].[StaffSchoolAssociationAcademicSubject] ssaas
  where exists 
  (select 1 from EdFi_Ods_2019.dbo.ssaas  ssaaALL
  where ssaas.StaffUSI = ssaaALL.StaffUSI
  and ssaas.AcademicSubjectDescriptorId <> ssaaALL.AcademicSubjectDescriptorId
  and ssaaALL.TableYear = 'ssa16'
  )
-- 69*2 = 138				-- change in 2017
-- 44*2 = 88				-- change in 2018
-- 27*2 = 54				-- change in 2019
-----
-- 140	  280
union
select 
TableYear,
[AcademicSubjectDescriptorId]
      ,[SchoolId]
      ,[StaffUSI]
	  ,2017 as ChangeYear
from EdFi_Ods_2019.dbo.ssaas  ssaaALL
where TableYear = 'ssa16'
and exists 
(select 1 from EdFi_Ods_2019.dbo.ssaas next where tableyear = 'ssa17'
and ssaaALL.StaffUSI = next.staffusi
and next.AcademicSubjectDescriptorId <> ssaaALL.AcademicSubjectDescriptorId
)
--order by StaffUSI, TableYear desc
------------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[2017_RoleChanged_Only]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- v1.0 created 7-24-2022

CREATE   VIEW [dbo].[2017_RoleChanged_Only]
as
-- 7-23-2022 cloned from RoleChanged_BeforeAfter and made Year over Year specific 
-- modifed 5-26-2022 to add some comments 
-- and add another query that is similar to the Good Good, but has the prior record be the most recent ODS Year
-- before the change
-- the new query commented -- Good -- old is most recent before change -- Good put the before and the after together
--
--the StaffClassificationDescriptorId (ROLE) change has no end date
--since the records are NOT accumulating, will need to check prior ods
--------------------------------------------------------------------------------------------------------
-- Good Good put the before and the after together
SELECT 'CurrentYear' as TableYear,
	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
      ,PositionTitle
	  ,2017 as ChangeYear
FROM [EdFi_Ods_2017].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa17
where seoaa17.StaffClassificationDescriptorId <> 2205
and staffusi in (select staffusi from  EdFi_Ods_2019.dbo.seoaa where TableYear = 'seoaa16'
and seoaa.StaffClassificationDescriptorId = 2205)
--  52	2017
--  46	2018
-- 124	2019
-------------
-- 222 changed in all years
--------------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[2017_NoChangeRoles_WITH_COHORT]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- v1.0 created 7-28-2022

CREATE   VIEW [dbo].[2017_NoChangeRoles_WITH_COHORT]
as
-- 7-23-2022 cloned from RoleChanged_BeforeAfter and made Year over Year specific 
-- modifed 5-26-2022 to add some comments 
-- and add another query that is similar to the Good Good, but has the prior record be the most recent ODS Year
-- before the change
-- the new query commented -- Good -- old is most recent before change -- Good put the before and the after together
--
--the StaffClassificationDescriptorId (ROLE) change has no end date
--since the records are NOT accumulating, will need to check prior ods
--------------------------------------------------------------------------------------------------------
-- Good Good put the before and the after together

SELECT 'CurrentYear' as TableYear,
	   BeginDate
      ,seoaa17.EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,seoaa17.StaffUSI
      ,PositionTitle
	  ,2017 as ChangeYear
	  ,ccy.SchoolYear as CertYear
FROM [EdFi_Ods_2017].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa17
inner join EdFi_Ods_2017.edfi.staff s
on seoaa17.StaffUSI = s.StaffUSI
inner join EdFi_Ods_2017.tpdm.Candidate c
on s.PersonId = c.PersonId
inner join EdFi_Ods_2017.tpdm.CandidateCohortYear ccy
on c.CandidateIdentifier = ccy.CandidateIdentifier
-- 847
-- 795
------
--  52
where 
seoaa17.StaffUSI not in (
select distinct staffusi from (
SELECT 'CurrentYear' as TableYear,
	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
      ,PositionTitle
	  ,2017 as ChangeYear
FROM [EdFi_Ods_2017].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa17
where seoaa17.StaffClassificationDescriptorId <> 2205
and staffusi in (select staffusi from  EdFi_Ods_2019.dbo.seoaa where TableYear = 'seoaa16'
and seoaa.StaffClassificationDescriptorId = 2205)
--  52	2017
--  46	2018
-- 124	2019
-------------
-- 222 changed in all years
union
select 
	   min(tableyear) as TableYear,			-- get the oldest prior and group out dupes
	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
      ,PositionTitle
	  ,2017 as ChangeYear
from EdFi_Ods_2019.dbo.seoaa seoaaALL
where seoaaALL.TableYear = 'seoaa16'
and seoaaALL.StaffClassificationDescriptorId = 2205
and seoaaALL.staffusi in
(SELECT StaffUSI
FROM [EdFi_Ods_2017].[edfi].[StaffEducationOrganizationAssignmentAssociation] seoaa17
where seoaa17.StaffClassificationDescriptorId <> 2205 
) -- 222 from the prior years
group by 	   BeginDate
      ,EducationOrganizationId
      ,StaffClassificationDescriptorId
      ,StaffUSI
      ,PositionTitle
) as yy
)
--order by StaffUSI, TableYear desc
-- 104	2017
--  92	2018
-- 248	2019
-- 444	with the current year records and the oldest prior year records that match on USI--------------------------------------------------------------------------------------------------------
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[vw_CurrentYearLocationChanges]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create View [dbo].[vw_CurrentYearLocationChanges] AS
Select * from dbo.[2017_LocationChanged_Only]
UNION ALL
SELECT * FROM dbo.[2018_LocationChanged_Only]
UNION ALL
select * from dbo.[2019_LocationChanged_Only]
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[vw_NoRoleChanged_WITH_COHORT]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- this is very similar to vw_NoRoleChanged but it also has a cohort field that can be filtered on

CREATE VIEW [dbo].[vw_NoRoleChanged_WITH_COHORT] AS
Select * from dbo.[2017_NoChangeRoles_WITH_COHORT]
UNION ALL
Select * from dbo.[2018_NoChangeRoles_WITH_COHORT]
UNION ALL
SELEct * from dbo.[2019_NoChangeRoles_WITH_COHORT]
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[vw_CombinedSubjectChange]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_CombinedSubjectChange] AS
Select * from [2017_SubjectChanged_Only] 
UNION ALL
SELEct * from dbo.[2018_SubjectChanged_Only]
UNION all 
Select * from dbo.[2019_SubjectChanged_Only]
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[vw_allsubjectchange]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[vw_allsubjectchange]  as 
select * from dbo.[2017_SubjectChanged_BeforeAfter]
union all
select * from dbo.[2018_SubjectChanged_BeforeAfter]
union all 
select * from dbo.[2019_SubjectChanged_BeforeAfter]
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[View_CurrentYearLocationChanges]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_CurrentYearLocationChanges]
AS
SELECT        dbo.vw_CurrentYearLocationChanges.*, dbo.SchoolAndDistrict.LEA_Name, dbo.SchoolAndDistrict.Campus, dbo.SchoolAndDistrict.CountyName, dbo.CandidateView.[Candidate Name]
FROM            dbo.vw_CurrentYearLocationChanges INNER JOIN
                         dbo.SchoolAndDistrict ON dbo.vw_CurrentYearLocationChanges.EducationOrganizationId = dbo.SchoolAndDistrict.SchoolNumber INNER JOIN
                         dbo.CandidateView ON dbo.vw_CurrentYearLocationChanges.StaffUSI = dbo.CandidateView.StaffUSI
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "vw_CurrentYearLocationChanges"
            Begin Extent = 
               Top = 32
               Left = 539
               Bottom = 348
               Right = 827
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SchoolAndDistrict"
            Begin Extent = 
               Top = 34
               Left = 213
               Bottom = 344
               Right = 430
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CandidateView"
            Begin Extent = 
               Top = 6
               Left = 865
               Bottom = 349
               Right = 1085
            End
            DisplayFlags = 280
            TopColumn = 12
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_CurrentYearLocationChanges'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_CurrentYearLocationChanges'
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[PrviousYearSubject]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[PrviousYearSubject]
AS

select * from (
SELECT * FROM [EdFi_Ods_2019].[dbo].[2017_SubjectChanged_BeforeAfter]
union
SELECT * FROM [EdFi_Ods_2019].[dbo].[2018_SubjectChanged_BeforeAfter]
union
SELECT * FROM [EdFi_Ods_2019].[dbo].[2019_SubjectChanged_BeforeAfter]
) as yy
where TableYear <> 'currentyear'

GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[View_SubjectChange]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_SubjectChange]
AS
SELECT        dbo.vw_CombinedSubjectChange.*, edfi.Descriptor.CodeValue
FROM            dbo.vw_CombinedSubjectChange INNER JOIN
                         edfi.Descriptor ON dbo.vw_CombinedSubjectChange.AcademicSubjectDescriptorId = edfi.Descriptor.DescriptorId
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "vw_CombinedSubjectChange"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 265
               Right = 283
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Descriptor (edfi)"
            Begin Extent = 
               Top = 6
               Left = 321
               Bottom = 255
               Right = 509
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 4605
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_SubjectChange'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_SubjectChange'
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[CandidateEmplAndNotEmpl]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 --9-5-2022 drop the XT suffix and just rename existing view to x...
 --7-31-2022 convert to XT (remove tpdm tables)

-- initial distributed to Tommy 3-26-2022
-- v1_0 corrected CertYear to be derrived from CredentialEventDate instead of HireDate
-- v1_1 modified to use correct tables and 2019 database 5-23-2022
-- v1.0 this version displays the rows deleted in 2018
-- v1.1 add EndDate in case Tommy needs to know when they left @@@@@
--		made from	dbo.CandidateView 
--					union 
--					dbo.CandidateView2017FutureDeletedRecords
--					union
--					dbo.CandidateView2018FutureDeletedRecords
-- v1.2 Left join the three changed views to get the booleans Tommy needs
-- note that the EndDate is for the DissappearedChange

CREATE   VIEW [dbo].[CandidateEmplAndNotEmpl]
as

select * from (
select yy.*,
case when lc.BeginDate is null then 'false' else 'true' end as LocChange 
,case when sc.schoolid is null then 'false' else 'true' end as SubjChange
,case when rc.PositionTitle is null then 'false' else 'true' end as RoleChange
,case when yy.enddate is null then 'false' else 'true' end as DisappearedChange
,case when lc.BeginDate is null and sc.SchoolId is null and rc.PositionTitle is null and yy.enddate is null
then 'true' else 'false' end as NoChange

from (
select 
seoaa.StaffUSI,
c.CandidateIdentifier,c.FirstName,c.LastSurname,c.SexDescriptorId,cr.RaceDescriptorId
,case when c.HispanicLatinoEthnicity = 1 then 'True' else 'False' end as HispanicLatinoEthnicity
,case when EconomicDisadvantaged = 1 then 'True' else '' end as EcononicDisadvantaged
,ccy.SchoolYear as Cohort
,case c.ProgramComplete	when 1 then 'True' else 'False' end as ProgramComplete							
--no--,StudentUSI			-- not using
,ceppa.ProgramName
--,cev.CredentialEventDate as BeginDate
,seoaa.BeginDate as EmploymentBeginDate
,ceppa.EducationOrganizationId
,c.PersonId,cred.IssuanceDate,
case when cev.CredentialEventDate > ' ' then 'true' else 'false' end as Credentialed,
cev.CredentialEventDate as [Certification Date],
--d6.CodeValue as CredentialType,			-- CredentialTypeDescriptor IS THIS USED ANYWHERE CONFUSING NAME
d7.CodeValue as CertificationType,
--no--cred.CredentialIdentifier,ceppa.EducationOrganizationId as [Campus ID],
seoaa.EducationOrganizationId as [Campus ID],
cast(case 
when SUBSTRING(cast(credentialeventdate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(credentialeventdate as varchar(10)),1,4) 
when SUBSTRING(cast(credentialeventdate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(credentialeventdate as varchar(10)),1,4)-1 end as int) as CertificationYear,
c.FirstName+' '+C.LastSurname as [Candidate Name],
d8.CodeValue as CertificationGradeLevel,
d9.CodeValue as CertificationSubjectArea, 
da.CodeValue as TeachingSubjectArea,
case isnull(seoaa.EndDate,'') when '' then 'Employed' else 'UnEmployed' end as Employed,
case when cred.EffectiveDate > '' then 'Certified' else '' end as Cerfified
-- EPP
,db.CodeValue as Position
,seoea.HireDate
,cast(case 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(HireDate as varchar(10)),1,4) 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(HireDate as varchar(10)),1,4)-1 end as varchar(11)) 
+'-'+
cast(
cast(case 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(HireDate as varchar(10)),1,4) 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(HireDate as varchar(10)),1,4)-1 end as int)+1 as varchar(11))
as BeginYear
,d1.codevalue as Race
,d2.codevalue as Sex
,cast(case 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4) 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4)-1 end as varchar(11)) 
+'-'+
cast(
cast(case 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4) 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4)-1 end as int)+1 as varchar(11))
as CertYear
,seoaa.EndDate		-- @@@@@ add 5-25-2022 @@@@@
-- 1289
-- after remove some garbled have 1277 rows 3-17-2022
--cred.*,
--credx.*,
--cev.*,
--cred.EffectiveDate,						-- Credential
--epp.*,
--,ccy.SchoolYear as Cohort,				-- CandidateCohortYear
--cev.CredentialEventDate,
--d7.codevalue,
--d6.CodeValue as CredentialType,			-- CredentialTypeDescriptor
--d5.CodeValue as CredentialStateOfIssue,	-- Credential StateOfIssueStateAbbreviationDescriptor
--d4.CodeValue as CredentialField,		-- CredentialField Descriptor -- only a subset are populated	
--c.CandidateIdentifier,c.FirstName,c.LastSurname
--,c.SexDescriptorId,d2.codevalue as Sex
--,cr.RaceDescriptorId,d1.CodeValue as 'Race' ,c.BirthDate
--,c.HispanicLatinoEthnicity,EconomicDisadvantaged,ProgramComplete
--,c.SourceSystemDescriptorId,d3.CodeValue as 'Source System'
--,c.EducationOrganizationId  
--select * 
from EdFi_Ods_2019.tpdm.Candidate c									-- 1 94 rows with Campus ID also in EdOrg as a district
inner join EdFi_Ods_2019.tpdm.CandidateRace cr						-- 2 94
on c.CandidateIdentifier = cr.CandidateIdentifier

inner join EdFi_Ods_2019.edfi.Descriptor d1							-- 3 94
on cr.RaceDescriptorId = d1.DescriptorId
and d1.namespace = 'uri://ed-fi.org/RaceDescriptor'

inner join EdFi_Ods_2019.edfi.SexDescriptor sd						-- 4 94
on c.SexDescriptorId = sd.SexDescriptorId
inner join EdFi_Ods_2019.edfi.Descriptor d2
on sd.SexDescriptorId = d2.DescriptorId

inner join EdFi_Ods_2019.edfi.SourceSystemDescriptor ssd			-- 5 94
on c.SourceSystemDescriptorId = ssd.SourceSystemDescriptorId
inner join EdFi_Ods_2019.edfi.Descriptor d3
on ssd.SourceSystemDescriptorId = d3.DescriptorId

inner join EdFi_Ods_2019.tpdm.credentialextension credx				-- 6 108
on c.PersonId = credx.personid 

inner join EdFi_Ods_2019.edfi.Credential cred						-- 7 108
on cred.CredentialIdentifier = credx.CredentialIdentifier

inner join EdFi_Ods_2019.tpdm.CredentialEvent cev					-- 8 108
on cred.EffectiveDate = cev.CredentialEventDate 
and cred.CredentialIdentifier = cev.CredentialIdentifier
and cred.StateOfIssueStateAbbreviationDescriptorId = cev.StateOfIssueStateAbbreviationDescriptorId

left join EdFi_Ods_2019.edfi.Descriptor d4							--  108
on cred.CredentialFieldDescriptorId = d4.DescriptorId

inner join EdFi_Ods_2019.edfi.Descriptor d5							--  108
on cred.StateOfIssueStateAbbreviationDescriptorId = d5.DescriptorId

inner join EdFi_Ods_2019.edfi.Descriptor d6							--  108
on cred.CredentialTypeDescriptorId = d6.DescriptorId
and d6.Namespace like '%credentialtype%'

inner join EdFi_Ods_2019.edfi.Descriptor d7
on cred.TeachingCredentialDescriptorId = d7.DescriptorId
and d7.Namespace = 'uri://ed-fi.org/TeachingCredentialDescriptor'

inner join EdFi_Ods_2019.edfi.CredentialGradeLevel cgl
on cred.CredentialIdentifier = cgl.CredentialIdentifier
inner join EdFi_Ods_2019.edfi.Descriptor d8
on cgl.GradeLevelDescriptorId = d8.DescriptorId

inner join EdFi_Ods_2019.edfi.CredentialAcademicSubject cas
on cred.CredentialIdentifier = cas.CredentialIdentifier
inner join EdFi_Ods_2019.edfi.Descriptor d9
on cas.AcademicSubjectDescriptorId = d9.DescriptorId

inner join EdFi_Ods_2019.tpdm.CandidateCohortYear ccy				-- 12 108
on ccy.CandidateIdentifier = c.CandidateIdentifier
-- 108
  
inner join EdFi_Ods_2019.tpdm.CandidateEducatorPreparationProgramAssociation ceppa	-- 13 108
on c.candidateidentifier = ceppa.candidateidentifier
  --and c.EducationOrganizationId = ceppa.EducationOrganizationId
  -- 108 rows 3-18-2022

inner join EdFi_Ods_2019.tpdm.EducatorPreparationProgram epp		-- 14 136
on epp.ProgramName = ceppa.ProgramName
and epp.ProgramTypeDescriptorId = ceppa.ProgramTypeDescriptorId
and epp.EducationOrganizationId = ceppa.EducationOrganizationId
--and epp.EducationOrganizationId = ceppa.EducationOrganizationId

inner join EdFi_Ods_2019.edfi.staff s								-- 15 136
on c.PersonId = s.PersonId

inner join EdFi_Ods_2019.edfi.EducationOrganization eo				-- 16 136
on ceppa.EducationOrganizationId = eo.EducationOrganizationId

inner join EdFi_Ods_2019.edfi.EducationOrganizationAddress eoa		-- 17 136
on eo.EducationOrganizationId = eoa.EducationOrganizationId

inner join EdFi_Ods_2019.edfi.StaffSchoolAssociation ssa
on s.staffusi = ssa.StaffUSI 
-- 136 rows

inner join EdFi_Ods_2019.edfi.StaffSchoolAssociationAcademicSubject ssaas
on ssa.staffusi = ssaas.StaffUSI 
--no--and ssa.SchoolId = ssaas.SchoolId				-- would like to get by without using the ssa schoolid -- may null
and ssa.ProgramAssignmentDescriptorId = ssaas.ProgramAssignmentDescriptorId
-- 136 rows

inner join EdFi_Ods_2019.edfi.Descriptor da
on ssaas.AcademicSubjectDescriptorId = da.DescriptorId
--136 rows

inner join EdFi_Ods_2019.edfi.StaffEducationOrganizationAssignmentAssociation seoaa
on ssaas.StaffUSI = seoaa.StaffUSI
and ssaas.SchoolId = seoaa.EducationOrganizationId
-- 136
inner join EdFi_Ods_2019.edfi.Descriptor db
on seoaa.StaffClassificationDescriptorId = db.DescriptorId
--136
inner join EdFi_Ods_2019.edfi.StaffEducationOrganizationEmploymentAssociation seoea
on seoaa.StaffUSI = seoea.StaffUSI
and seoaa.EducationOrganizationId = seoea.EducationOrganizationId
and seoaa.BeginDate = seoea.HireDate
--136
--x-left join EdFi_Ods_2019.edfi.student stu	-- do not need student
--x-on c.PersonId = stu.PersonId
-- 136 rows

where seoaa.EndDate is null and seoea.EndDate is null
union
-- 2017
select 
seoaa.StaffUSI,
c.CandidateIdentifier,c.FirstName,c.LastSurname,c.SexDescriptorId,cr.RaceDescriptorId
,case when c.HispanicLatinoEthnicity = 1 then 'True' else 'False' end as HispanicLatinoEthnicity
,case when EconomicDisadvantaged = 1 then 'True' else '' end as EcononicDisadvantaged
,ccy.SchoolYear as Cohort
,case c.ProgramComplete	when 1 then 'True' else 'False' end as ProgramComplete							
--no--,StudentUSI			-- not using
,ceppa.ProgramName
--,cev.CredentialEventDate as BeginDate
,seoaa.BeginDate as EmploymentBeginDate
,ceppa.EducationOrganizationId
,c.PersonId,cred.IssuanceDate,
case when cev.CredentialEventDate > ' ' then 'true' else 'false' end as Credentialed,
cev.CredentialEventDate as [Certification Date],
--d6.CodeValue as CredentialType,			-- CredentialTypeDescriptor IS THIS USED ANYWHERE CONFUSING NAME
d7.CodeValue as CertificationType,
--no--cred.CredentialIdentifier,ceppa.EducationOrganizationId as [Campus ID],
seoaa.EducationOrganizationId as [Campus ID],
cast(case 
when SUBSTRING(cast(credentialeventdate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(credentialeventdate as varchar(10)),1,4) 
when SUBSTRING(cast(credentialeventdate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(credentialeventdate as varchar(10)),1,4)-1 end as int) as CertificationYear,
c.FirstName+' '+C.LastSurname as [Candidate Name],
d8.CodeValue as CertificationGradeLevel,
d9.CodeValue as CertificationSubjectArea, 
da.CodeValue as TeachingSubjectArea,
case isnull(seoaa.EndDate,'') when '' then 'Employed' else 'UnEmployed' end as Employed,
case when cred.EffectiveDate > '' then 'Certified' else '' end as Cerfified
-- EPP
,db.CodeValue as Position
,seoea.HireDate
,cast(case 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(HireDate as varchar(10)),1,4) 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(HireDate as varchar(10)),1,4)-1 end as varchar(11)) 
+'-'+
cast(
cast(case 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(HireDate as varchar(10)),1,4) 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(HireDate as varchar(10)),1,4)-1 end as int)+1 as varchar(11))
as BeginYear
,d1.codevalue as Race
,d2.codevalue as Sex
,cast(case 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4) 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4)-1 end as varchar(11)) 
+'-'+
cast(
cast(case 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4) 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4)-1 end as int)+1 as varchar(11))
as CertYear
,seoaa.EndDate		-- @@@@@ add 5-25-2022 @@@@@
-- 1289
-- after remove some garbled have 1277 rows 3-17-2022
--cred.*,
--credx.*,
--cev.*,
--cred.EffectiveDate,						-- Credential
--epp.*,
--,ccy.SchoolYear as Cohort,				-- CandidateCohortYear
--cev.CredentialEventDate,
--d7.codevalue,
--d6.CodeValue as CredentialType,			-- CredentialTypeDescriptor
--d5.CodeValue as CredentialStateOfIssue,	-- Credential StateOfIssueStateAbbreviationDescriptor
--d4.CodeValue as CredentialField,		-- CredentialField Descriptor -- only a subset are populated	
--c.CandidateIdentifier,c.FirstName,c.LastSurname
--,c.SexDescriptorId,d2.codevalue as Sex
--,cr.RaceDescriptorId,d1.CodeValue as 'Race' ,c.BirthDate
--,c.HispanicLatinoEthnicity,EconomicDisadvantaged,ProgramComplete
--,c.SourceSystemDescriptorId,d3.CodeValue as 'Source System'
--,c.EducationOrganizationId  
--select * 
from EdFi_Ods_2019.tpdm.Candidate c									-- 1 94 rows with Campus ID also in EdOrg as a district
inner join EdFi_Ods_2019.tpdm.CandidateRace cr						-- 2 94
on c.CandidateIdentifier = cr.CandidateIdentifier

inner join EdFi_Ods_2019.edfi.Descriptor d1							-- 3 94
on cr.RaceDescriptorId = d1.DescriptorId
and d1.namespace = 'uri://ed-fi.org/RaceDescriptor'

inner join EdFi_Ods_2019.edfi.SexDescriptor sd						-- 4 94
on c.SexDescriptorId = sd.SexDescriptorId
inner join EdFi_Ods_2019.edfi.Descriptor d2
on sd.SexDescriptorId = d2.DescriptorId

inner join EdFi_Ods_2019.edfi.SourceSystemDescriptor ssd			-- 5 94
on c.SourceSystemDescriptorId = ssd.SourceSystemDescriptorId
inner join EdFi_Ods_2019.edfi.Descriptor d3
on ssd.SourceSystemDescriptorId = d3.DescriptorId

inner join EdFi_Ods_2019.tpdm.credentialextension credx				-- 6 108
on c.PersonId = credx.personid 

inner join EdFi_Ods_2019.edfi.Credential cred						-- 7 108
on cred.CredentialIdentifier = credx.CredentialIdentifier

inner join EdFi_Ods_2019.tpdm.CredentialEvent cev					-- 8 108
on cred.EffectiveDate = cev.CredentialEventDate 
and cred.CredentialIdentifier = cev.CredentialIdentifier
and cred.StateOfIssueStateAbbreviationDescriptorId = cev.StateOfIssueStateAbbreviationDescriptorId

left join EdFi_Ods_2019.edfi.Descriptor d4							--  108
on cred.CredentialFieldDescriptorId = d4.DescriptorId

inner join EdFi_Ods_2019.edfi.Descriptor d5							--  108
on cred.StateOfIssueStateAbbreviationDescriptorId = d5.DescriptorId

inner join EdFi_Ods_2019.edfi.Descriptor d6							--  108
on cred.CredentialTypeDescriptorId = d6.DescriptorId
and d6.Namespace like '%credentialtype%'

inner join EdFi_Ods_2019.edfi.Descriptor d7
on cred.TeachingCredentialDescriptorId = d7.DescriptorId
and d7.Namespace = 'uri://ed-fi.org/TeachingCredentialDescriptor'

inner join EdFi_Ods_2019.edfi.CredentialGradeLevel cgl
on cred.CredentialIdentifier = cgl.CredentialIdentifier
inner join EdFi_Ods_2019.edfi.Descriptor d8
on cgl.GradeLevelDescriptorId = d8.DescriptorId

inner join EdFi_Ods_2019.edfi.CredentialAcademicSubject cas
on cred.CredentialIdentifier = cas.CredentialIdentifier
inner join EdFi_Ods_2019.edfi.Descriptor d9
on cas.AcademicSubjectDescriptorId = d9.DescriptorId

inner join EdFi_Ods_2019.tpdm.CandidateCohortYear ccy				-- 12 108
on ccy.CandidateIdentifier = c.CandidateIdentifier
-- 108
  
inner join EdFi_Ods_2019.tpdm.CandidateEducatorPreparationProgramAssociation ceppa	-- 13 108
on c.candidateidentifier = ceppa.candidateidentifier
  --and c.EducationOrganizationId = ceppa.EducationOrganizationId
  -- 108 rows 3-18-2022

inner join EdFi_Ods_2019.tpdm.EducatorPreparationProgram epp		-- 14 136
on epp.ProgramName = ceppa.ProgramName
and epp.ProgramTypeDescriptorId = ceppa.ProgramTypeDescriptorId
and epp.EducationOrganizationId = ceppa.EducationOrganizationId
--and epp.EducationOrganizationId = ceppa.EducationOrganizationId

inner join EdFi_Ods_2019.edfi.staff s								-- 15 136
on c.PersonId = s.PersonId

inner join EdFi_Ods_2019.edfi.EducationOrganization eo				-- 16 136
on ceppa.EducationOrganizationId = eo.EducationOrganizationId

inner join EdFi_Ods_2019.edfi.EducationOrganizationAddress eoa		-- 17 136
on eo.EducationOrganizationId = eoa.EducationOrganizationId

inner join EdFi_Ods_2017.edfi.StaffSchoolAssociation ssa
on s.staffusi = ssa.StaffUSI 
------------------------------------------------------------------------------------------------------
--LEFT join EdFi_Ods_2017.edfi.StaffSchoolAssociation ssa
--on s.staffusi = ssa.StaffUSI 
-- 1224
-- where ssa.ProgramAssignmentDescriptorId is null
--  429 null
-- where ssa.ProgramAssignmentDescriptorId is not null
--  795 not null
------
-- 1224
------------------------------------------------------------------------------------------------------

inner join EdFi_Ods_2017.edfi.StaffSchoolAssociationAcademicSubject ssaas
on ssa.staffusi = ssaas.StaffUSI 
-- 795
--
--no--and ssa.SchoolId = ssaas.SchoolId				-- would like to get by without using the ssa schoolid -- may null
and ssa.ProgramAssignmentDescriptorId = ssaas.ProgramAssignmentDescriptorId
-- 136 rows

inner join EdFi_Ods_2017.edfi.Descriptor da
on ssaas.AcademicSubjectDescriptorId = da.DescriptorId
--795

inner join EdFi_Ods_2017.edfi.StaffEducationOrganizationAssignmentAssociation seoaa
on ssaas.StaffUSI = seoaa.StaffUSI
and ssaas.SchoolId = seoaa.EducationOrganizationId
--795
inner join EdFi_Ods_2017.edfi.Descriptor db
on seoaa.StaffClassificationDescriptorId = db.DescriptorId
--136
inner join EdFi_Ods_2017.edfi.StaffEducationOrganizationEmploymentAssociation seoea
on seoaa.StaffUSI = seoea.StaffUSI
and seoaa.EducationOrganizationId = seoea.EducationOrganizationId
and seoaa.BeginDate = seoea.HireDate
--795

--where seoaa.EndDate is null and seoea.EndDate is null
--765 after end-dated records are filtered out NOT SURE WE WANT TO DO THAT FOR OUR DISSAPPEARED VIEW
where seoaa.StaffUSI in (
select StaffUSI from EdFi_Ods_2017.edfi.StaffEducationOrganizationAssignmentAssociation seoaa17
where not exists
(select 1 from EdFi_Ods_2018.edfi.StaffEducationOrganizationAssignmentAssociation seoaa18
where seoaa17.StaffUSI = seoaa18.StaffUSI)
)
--where seoaa.StaffUSI in (select staffusi from tpdm.dbo.[2017ListForDisappear])
union -- 2018
select 
seoaa.StaffUSI,
c.CandidateIdentifier,c.FirstName,c.LastSurname,c.SexDescriptorId,cr.RaceDescriptorId
,case when c.HispanicLatinoEthnicity = 1 then 'True' else 'False' end as HispanicLatinoEthnicity
,case when EconomicDisadvantaged = 1 then 'True' else '' end as EcononicDisadvantaged
,ccy.SchoolYear as Cohort
,case c.ProgramComplete	when 1 then 'True' else 'False' end as ProgramComplete							
--no--,StudentUSI			-- not using
,ceppa.ProgramName
--,cev.CredentialEventDate as BeginDate
,seoaa.BeginDate as EmploymentBeginDate
,ceppa.EducationOrganizationId
,c.PersonId,cred.IssuanceDate,
case when cev.CredentialEventDate > ' ' then 'true' else 'false' end as Credentialed,
cev.CredentialEventDate as [Certification Date],
--d6.CodeValue as CredentialType,			-- CredentialTypeDescriptor IS THIS USED ANYWHERE CONFUSING NAME
d7.CodeValue as CertificationType,
--no--cred.CredentialIdentifier,ceppa.EducationOrganizationId as [Campus ID],
seoaa.EducationOrganizationId as [Campus ID],
cast(case 
when SUBSTRING(cast(credentialeventdate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(credentialeventdate as varchar(10)),1,4) 
when SUBSTRING(cast(credentialeventdate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(credentialeventdate as varchar(10)),1,4)-1 end as int) as CertificationYear,
c.FirstName+' '+C.LastSurname as [Candidate Name],
d8.CodeValue as CertificationGradeLevel,
d9.CodeValue as CertificationSubjectArea, 
da.CodeValue as TeachingSubjectArea,
case isnull(seoaa.EndDate,'') when '' then 'Employed' else 'UnEmployed' end as Employed,
case when cred.EffectiveDate > '' then 'Certified' else '' end as Cerfified
-- EPP
,db.CodeValue as Position
,seoea.HireDate
,cast(case 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(HireDate as varchar(10)),1,4) 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(HireDate as varchar(10)),1,4)-1 end as varchar(11)) 
+'-'+
cast(
cast(case 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(HireDate as varchar(10)),1,4) 
when SUBSTRING(cast(HireDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(HireDate as varchar(10)),1,4)-1 end as int)+1 as varchar(11))
as BeginYear
,d1.codevalue as Race
,d2.codevalue as Sex
,cast(case 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4) 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4)-1 end as varchar(11)) 
+'-'+
cast(
cast(case 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('09','10','11','12')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4) 
when SUBSTRING(cast(CredentialEventDate as varchar(10)),6,2) in ('01','02','03','04','05','06','07','08')
then SUBSTRING(cast(CredentialEventDate as varchar(10)),1,4)-1 end as int)+1 as varchar(11))
as CertYear
,seoaa.EndDate		-- @@@@@ add 5-25-2022 @@@@@
-- 1289
-- after remove some garbled have 1277 rows 3-17-2022
--cred.*,
--credx.*,
--cev.*,
--cred.EffectiveDate,						-- Credential
--epp.*,
--,ccy.SchoolYear as Cohort,				-- CandidateCohortYear
--cev.CredentialEventDate,
--d7.codevalue,
--d6.CodeValue as CredentialType,			-- CredentialTypeDescriptor
--d5.CodeValue as CredentialStateOfIssue,	-- Credential StateOfIssueStateAbbreviationDescriptor
--d4.CodeValue as CredentialField,		-- CredentialField Descriptor -- only a subset are populated	
--c.CandidateIdentifier,c.FirstName,c.LastSurname
--,c.SexDescriptorId,d2.codevalue as Sex
--,cr.RaceDescriptorId,d1.CodeValue as 'Race' ,c.BirthDate
--,c.HispanicLatinoEthnicity,EconomicDisadvantaged,ProgramComplete
--,c.SourceSystemDescriptorId,d3.CodeValue as 'Source System'
--,c.EducationOrganizationId  
--select * 
from EdFi_Ods_2019.tpdm.Candidate c									-- 1 94 rows with Campus ID also in EdOrg as a district
inner join EdFi_Ods_2019.tpdm.CandidateRace cr						-- 2 94
on c.CandidateIdentifier = cr.CandidateIdentifier

inner join EdFi_Ods_2019.edfi.Descriptor d1							-- 3 94
on cr.RaceDescriptorId = d1.DescriptorId
and d1.namespace = 'uri://ed-fi.org/RaceDescriptor'

inner join EdFi_Ods_2019.edfi.SexDescriptor sd						-- 4 94
on c.SexDescriptorId = sd.SexDescriptorId
inner join EdFi_Ods_2019.edfi.Descriptor d2
on sd.SexDescriptorId = d2.DescriptorId

inner join EdFi_Ods_2019.edfi.SourceSystemDescriptor ssd			-- 5 94
on c.SourceSystemDescriptorId = ssd.SourceSystemDescriptorId
inner join EdFi_Ods_2019.edfi.Descriptor d3
on ssd.SourceSystemDescriptorId = d3.DescriptorId

inner join EdFi_Ods_2019.tpdm.credentialextension credx				-- 6 108
on c.PersonId = credx.personid 

inner join EdFi_Ods_2019.edfi.Credential cred						-- 7 108
on cred.CredentialIdentifier = credx.CredentialIdentifier

inner join EdFi_Ods_2019.tpdm.CredentialEvent cev					-- 8 108
on cred.EffectiveDate = cev.CredentialEventDate 
and cred.CredentialIdentifier = cev.CredentialIdentifier
and cred.StateOfIssueStateAbbreviationDescriptorId = cev.StateOfIssueStateAbbreviationDescriptorId

left join EdFi_Ods_2019.edfi.Descriptor d4							--  108
on cred.CredentialFieldDescriptorId = d4.DescriptorId

inner join EdFi_Ods_2019.edfi.Descriptor d5							--  108
on cred.StateOfIssueStateAbbreviationDescriptorId = d5.DescriptorId

inner join EdFi_Ods_2019.edfi.Descriptor d6							--  108
on cred.CredentialTypeDescriptorId = d6.DescriptorId
and d6.Namespace like '%credentialtype%'

inner join EdFi_Ods_2019.edfi.Descriptor d7
on cred.TeachingCredentialDescriptorId = d7.DescriptorId
and d7.Namespace = 'uri://ed-fi.org/TeachingCredentialDescriptor'

inner join EdFi_Ods_2019.edfi.CredentialGradeLevel cgl
on cred.CredentialIdentifier = cgl.CredentialIdentifier
inner join EdFi_Ods_2019.edfi.Descriptor d8
on cgl.GradeLevelDescriptorId = d8.DescriptorId

inner join EdFi_Ods_2019.edfi.CredentialAcademicSubject cas
on cred.CredentialIdentifier = cas.CredentialIdentifier
inner join EdFi_Ods_2019.edfi.Descriptor d9
on cas.AcademicSubjectDescriptorId = d9.DescriptorId

inner join EdFi_Ods_2019.tpdm.CandidateCohortYear ccy				-- 12 108
on ccy.CandidateIdentifier = c.CandidateIdentifier
-- 108
  
inner join EdFi_Ods_2019.tpdm.CandidateEducatorPreparationProgramAssociation ceppa	-- 13 108
on c.candidateidentifier = ceppa.candidateidentifier
  --and c.EducationOrganizationId = ceppa.EducationOrganizationId
  -- 108 rows 3-18-2022

inner join EdFi_Ods_2019.tpdm.EducatorPreparationProgram epp		-- 14 136
on epp.ProgramName = ceppa.ProgramName
and epp.ProgramTypeDescriptorId = ceppa.ProgramTypeDescriptorId
and epp.EducationOrganizationId = ceppa.EducationOrganizationId
--and epp.EducationOrganizationId = ceppa.EducationOrganizationId

inner join EdFi_Ods_2019.edfi.staff s								-- 15 136
on c.PersonId = s.PersonId

inner join EdFi_Ods_2019.edfi.EducationOrganization eo				-- 16 136
on ceppa.EducationOrganizationId = eo.EducationOrganizationId

inner join EdFi_Ods_2019.edfi.EducationOrganizationAddress eoa		-- 17 136
on eo.EducationOrganizationId = eoa.EducationOrganizationId

inner join EdFi_Ods_2018.edfi.StaffSchoolAssociation ssa
on s.staffusi = ssa.StaffUSI 
------------------------------------------------------------------------------------------------------
--LEFT join EdFi_Ods_2018.edfi.StaffSchoolAssociation ssa
--on s.staffusi = ssa.StaffUSI 
-- 1224
-- where ssa.ProgramAssignmentDescriptorId is null
--  429 null
-- where ssa.ProgramAssignmentDescriptorId is not null
--  795 not null
------
-- 1224
------------------------------------------------------------------------------------------------------

inner join EdFi_Ods_2018.edfi.StaffSchoolAssociationAcademicSubject ssaas
on ssa.staffusi = ssaas.StaffUSI 
-- 795
--
--no--and ssa.SchoolId = ssaas.SchoolId				-- would like to get by without using the ssa schoolid -- may null
and ssa.ProgramAssignmentDescriptorId = ssaas.ProgramAssignmentDescriptorId
-- 136 rows

inner join EdFi_Ods_2018.edfi.Descriptor da
on ssaas.AcademicSubjectDescriptorId = da.DescriptorId
--795

inner join EdFi_Ods_2018.edfi.StaffEducationOrganizationAssignmentAssociation seoaa
on ssaas.StaffUSI = seoaa.StaffUSI
and ssaas.SchoolId = seoaa.EducationOrganizationId
--795
inner join EdFi_Ods_2018.edfi.Descriptor db
on seoaa.StaffClassificationDescriptorId = db.DescriptorId
--136
inner join EdFi_Ods_2018.edfi.StaffEducationOrganizationEmploymentAssociation seoea
on seoaa.StaffUSI = seoea.StaffUSI
and seoaa.EducationOrganizationId = seoea.EducationOrganizationId
and seoaa.BeginDate = seoea.HireDate
--795

--where seoaa.EndDate is null and seoea.EndDate is null
--765 after end-dated records are filtered out NOT SURE WE WANT TO DO THAT FOR OUR DISSAPPEARED VIEW

where seoaa.StaffUSI in (
select StaffUSI from EdFi_Ods_2018.edfi.StaffEducationOrganizationAssignmentAssociation seoaa18
where not exists
(select 1 from EdFi_Ods_2019.edfi.StaffEducationOrganizationAssignmentAssociation seoaa19
where seoaa18.StaffUSI = seoaa19.StaffUSI)
)
--where seoaa.StaffUSI in (select staffusi from tpdm.dbo.[2018ListForDisappear])

--order by StaffUSI
) as yy
left join EdFi_Ods_2019.dbo.LocationChanged_BeforeOnly lc on yy.StaffUSI = lc.StaffUSI 
--and lc.EndDate is not null
left join EdFi_Ods_2019.dbo.SubjectChanged_BeforeOnly sc on yy.StaffUSI = sc.StaffUSI 
--and sc.TableYear = 'currentyear'
left join EdFi_Ods_2019.dbo.RoleChanged_BeforeOnly rc on yy.StaffUSI = rc.StaffUSI 
--and rc.StaffClassificationDescriptorId <> 2205
) as zz

--where disappearedchange = 'true'	-- 60
--where zz.LocChange = 'true'		-- 152
--where zz.RoleChange = 'true'		-- 222
--where zz.SubjChange = 'true'		-- 140
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[vw_PreviousSubject]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_PreviousSubject]
AS
SELECT        edfi.Descriptor.CodeValue, dbo.PrviousYearSubject.TableYear, dbo.PrviousYearSubject.SchoolId, dbo.PrviousYearSubject.StaffUSI, dbo.PrviousYearSubject.ChangeYear, dbo.CandidateView.[Candidate Name]
FROM            edfi.Descriptor INNER JOIN
                         dbo.PrviousYearSubject ON edfi.Descriptor.DescriptorId = dbo.PrviousYearSubject.AcademicSubjectDescriptorId INNER JOIN
                         dbo.CandidateView ON dbo.PrviousYearSubject.StaffUSI = dbo.CandidateView.StaffUSI
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Descriptor (edfi)"
            Begin Extent = 
               Top = 24
               Left = 206
               Bottom = 268
               Right = 394
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PrviousYearSubject"
            Begin Extent = 
               Top = 27
               Left = 420
               Bottom = 293
               Right = 665
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CandidateView"
            Begin Extent = 
               Top = 6
               Left = 762
               Bottom = 319
               Right = 982
            End
            DisplayFlags = 280
            TopColumn = 12
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 3720
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 3030
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_PreviousSubject'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_PreviousSubject'
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[vw_allSubjectChangewsubjectname]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_allSubjectChangewsubjectname]
AS
SELECT        edfi.Descriptor.CodeValue, dbo.vw_allsubjectchange.*, dbo.CandidateEmplAndNotEmpl.[Candidate Name]
FROM            edfi.Descriptor INNER JOIN
                         dbo.vw_allsubjectchange ON edfi.Descriptor.DescriptorId = dbo.vw_allsubjectchange.AcademicSubjectDescriptorId INNER JOIN
                         dbo.CandidateEmplAndNotEmpl ON dbo.vw_allsubjectchange.StaffUSI = dbo.CandidateEmplAndNotEmpl.StaffUSI
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Descriptor (edfi)"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 242
               Right = 226
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_allsubjectchange"
            Begin Extent = 
               Top = 6
               Left = 264
               Bottom = 277
               Right = 509
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "CandidateEmplAndNotEmpl"
            Begin Extent = 
               Top = 6
               Left = 547
               Bottom = 314
               Right = 767
            End
            DisplayFlags = 280
            TopColumn = 14
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_allSubjectChangewsubjectname'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_allSubjectChangewsubjectname'
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[RoleChanges]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE   VIEW [dbo].[RoleChanges]
as
-- 11-5-2022 
select 'Change' as TableYear,BeginDate,yy.EducationOrganizationId
,StaffClassificationDescriptorId,yy.StaffUSI,PositionTitle,ChangeYear
,CertificationYear
from 
(
SELECT * FROM [EdFi_Ods_2019].[dbo].[2017_RoleChanged_Only]
union
SELECT * FROM [EdFi_Ods_2019].[dbo].[2018_RoleChanged_Only]
union
SELECT * FROM [EdFi_Ods_2019].[dbo].[2019_RoleChanged_Only]
) as yy
inner join 
[EdFi_Ods_2019].[dbo].[CandidateEmplAndNotEmpl] ceane
on yy.StaffUSI = ceane.StaffUSI

GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[vw_CurrentSubjectChange]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_CurrentSubjectChange]
AS
SELECT        dbo.CandidateView.[Candidate Name], dbo.View_SubjectChange.*
FROM            dbo.View_SubjectChange INNER JOIN
                         dbo.CandidateView ON dbo.View_SubjectChange.StaffUSI = dbo.CandidateView.StaffUSI
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "CandidateView"
            Begin Extent = 
               Top = 36
               Left = 772
               Bottom = 276
               Right = 992
            End
            DisplayFlags = 280
            TopColumn = 13
         End
         Begin Table = "View_SubjectChange"
            Begin Extent = 
               Top = 16
               Left = 202
               Bottom = 303
               Right = 447
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 2850
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_CurrentSubjectChange'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_CurrentSubjectChange'
GO
USE [EdFi_Ods_2019]
GO
/****** Object:  View [dbo].[ChangeInRole_All]    Script Date: 11/27/2022 9:25:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Script for SelectTopNRows command from SSMS  ******/
create view [dbo].[ChangeInRole_All]
as
select * from RoleChanges
union all
select * from [dbo].[vw_NoRoleChanged_WITH_COHORT]
GO
