USE [master]
GO
/****** Object:  Database [Questionnaire]    Script Date: 10/29/2021 7:02:12 PM ******/
CREATE DATABASE [Questionnaire]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Questionnaire', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Questionnaire.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Questionnaire_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Questionnaire_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Questionnaire] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Questionnaire].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Questionnaire] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Questionnaire] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Questionnaire] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Questionnaire] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Questionnaire] SET ARITHABORT OFF 
GO
ALTER DATABASE [Questionnaire] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Questionnaire] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Questionnaire] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Questionnaire] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Questionnaire] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Questionnaire] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Questionnaire] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Questionnaire] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Questionnaire] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Questionnaire] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Questionnaire] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Questionnaire] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Questionnaire] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Questionnaire] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Questionnaire] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Questionnaire] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Questionnaire] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Questionnaire] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Questionnaire] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Questionnaire] SET  MULTI_USER 
GO
ALTER DATABASE [Questionnaire] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Questionnaire] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Questionnaire] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Questionnaire] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [Questionnaire]
GO
/****** Object:  Table [dbo].[Answer]    Script Date: 10/29/2021 7:02:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Answer](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[VoterID] [uniqueidentifier] NOT NULL,
	[QuestionID] [uniqueidentifier] NOT NULL,
	[OptionID] [uniqueidentifier] NULL,
	[TextboxContent] [nvarchar](max) NULL,
	[Timestamp] [date] NOT NULL,
 CONSTRAINT [PK_Answer] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Option]    Script Date: 10/29/2021 7:02:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Option](
	[OptionID] [uniqueidentifier] NOT NULL,
	[QuestionID] [uniqueidentifier] NOT NULL,
	[OptionContent] [nvarchar](max) NOT NULL,
	[Number] [int] NOT NULL,
 CONSTRAINT [PK_Option] PRIMARY KEY CLUSTERED 
(
	[OptionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Question]    Script Date: 10/29/2021 7:02:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Question](
	[QuestionID] [uniqueidentifier] NOT NULL,
	[QuestionnaireID] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Type] [int] NOT NULL,
	[Required] [int] NOT NULL,
	[Number] [int] NOT NULL,
 CONSTRAINT [PK_Question] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Questionnaire]    Script Date: 10/29/2021 7:02:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Questionnaire](
	[QuestionnaireID] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Discription] [nvarchar](max) NULL,
	[Status] [int] NOT NULL,
	[StartDate] [date] NOT NULL,
	[EndDate] [date] NULL,
 CONSTRAINT [PK_Questionnaire] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Voter]    Script Date: 10/29/2021 7:02:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Voter](
	[VoterID] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Phone] [varchar](50) NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[Age] [int] NOT NULL,
 CONSTRAINT [PK_Voter] PRIMARY KEY CLUSTERED 
(
	[VoterID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Answer] ON 

INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (2, N'65564652-410f-442c-b70a-f9aebe2f5f5b', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'ae8a5d00-117f-43fe-9989-3a3e435cdfe8', N'', CAST(N'2021-10-27' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (3, N'2b98c0e6-2b9d-4707-938b-e825bac047d9', N'5dff9795-09a3-4a59-8746-6660f6e67c3a', N'14655798-5fab-4092-a56d-8a339a954b76', N'', CAST(N'2021-10-27' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (4, N'2b98c0e6-2b9d-4707-938b-e825bac047d9', N'5dff9795-09a3-4a59-8746-6660f6e67c3a', N'cd528b5a-85a5-4a6b-9919-a2496599caa5', N'', CAST(N'2021-10-27' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (5, N'2b98c0e6-2b9d-4707-938b-e825bac047d9', N'5dff9795-09a3-4a59-8746-6660f6e67c3a', N'b266b8ef-d795-4d21-ab7a-03f8ff579626', N'', CAST(N'2021-10-27' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (6, N'2b98c0e6-2b9d-4707-938b-e825bac047d9', N'3fd8e3fc-b72d-4b29-954d-2ed7a611cfe3', NULL, N'', CAST(N'2021-10-27' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (7, N'2eaaac13-23ec-4eea-b786-d282fa39b0d2', N'81ecc6d2-42c3-450e-b63c-6587b4bf9fb3', N'528d05d5-f7eb-49f8-a415-9183606accdd', N'', CAST(N'2021-10-27' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (8, N'2eaaac13-23ec-4eea-b786-d282fa39b0d2', N'1e0d8ab7-4012-4129-8783-51f48d2fe440', NULL, N'新世紀福音戰士', CAST(N'2021-10-27' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (9, N'37cb6729-4cc0-4ae9-82c4-24123ac097e8', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'17583b81-29c4-4c6b-ba55-87592693d392', N'', CAST(N'2021-10-28' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (10, N'c64d90eb-931a-44ac-9117-ded2af2bb8bb', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'3da932b9-7336-4f84-a8e1-86df607b2dc6', N'', CAST(N'2021-10-28' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (11, N'f836390f-d4cf-476e-b6bc-fd1ab0c5757b', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'9095fff0-fab0-4bde-8de2-59576ed2a2cf', N'', CAST(N'2021-10-28' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (12, N'3ef53684-10ca-400a-bca1-f31f27ce22ba', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'17583b81-29c4-4c6b-ba55-87592693d392', N'', CAST(N'2021-10-28' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (13, N'cd42c301-971c-4824-80fa-eac0a6b2b4f2', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'e233ac89-e253-47ed-982a-fac2cd4bf48e', N'', CAST(N'2021-10-28' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (14, N'7ecb6da4-50bf-45dc-b538-deb8ed63bc54', N'5dff9795-09a3-4a59-8746-6660f6e67c3a', N'e7ca9da4-0fa4-4402-8a10-ba5bc2b5bbd4', N'', CAST(N'2021-10-28' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (15, N'7ecb6da4-50bf-45dc-b538-deb8ed63bc54', N'5dff9795-09a3-4a59-8746-6660f6e67c3a', N'bd1d9b93-6a70-4eb8-853b-f49ecac23733', N'', CAST(N'2021-10-28' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (16, N'7ecb6da4-50bf-45dc-b538-deb8ed63bc54', N'5dff9795-09a3-4a59-8746-6660f6e67c3a', N'cd528b5a-85a5-4a6b-9919-a2496599caa5', N'', CAST(N'2021-10-28' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (17, N'7ecb6da4-50bf-45dc-b538-deb8ed63bc54', N'3fd8e3fc-b72d-4b29-954d-2ed7a611cfe3', NULL, N'Son La', CAST(N'2021-10-28' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (18, N'5fd8da05-f12d-44cd-a33a-6452f9c80cfc', N'5dff9795-09a3-4a59-8746-6660f6e67c3a', N'bd1d9b93-6a70-4eb8-853b-f49ecac23733', N'', CAST(N'2021-10-28' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (19, N'5fd8da05-f12d-44cd-a33a-6452f9c80cfc', N'5dff9795-09a3-4a59-8746-6660f6e67c3a', N'5322f39f-3834-4fc0-851c-c6e59c2e4d63', N'', CAST(N'2021-10-28' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (20, N'5fd8da05-f12d-44cd-a33a-6452f9c80cfc', N'3fd8e3fc-b72d-4b29-954d-2ed7a611cfe3', NULL, N'', CAST(N'2021-10-28' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (21, N'ab492e72-3280-4c73-a544-9bf7ba6a0a3e', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'0f95034b-d607-4f84-b06d-0c2f4e679f98', N'', CAST(N'2021-10-29' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (22, N'ab492e72-3280-4c73-a544-9bf7ba6a0a3e', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'a0b50ae1-6e4b-4b43-bf1b-f6466e5f1174', N'', CAST(N'2021-10-29' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (23, N'ab492e72-3280-4c73-a544-9bf7ba6a0a3e', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'14b04308-a456-4234-ba4e-863e2735a017', N'', CAST(N'2021-10-29' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (24, N'2b86e9c6-ae6b-409b-b79f-b22e97395745', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'db5534ba-2a00-4e7c-a519-bb5bee09dcc3', N'', CAST(N'2021-10-29' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (25, N'2b86e9c6-ae6b-409b-b79f-b22e97395745', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'b4da8861-9e8d-4c9f-8dac-1cd0625ac311', N'', CAST(N'2021-10-29' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (26, N'9e481dd8-1a96-4ea0-b74c-9486fe6132d5', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'a0b50ae1-6e4b-4b43-bf1b-f6466e5f1174', N'', CAST(N'2021-10-29' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (27, N'9e481dd8-1a96-4ea0-b74c-9486fe6132d5', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'14b04308-a456-4234-ba4e-863e2735a017', N'', CAST(N'2021-10-29' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (28, N'ec1b5c5c-bab2-424e-a2a4-ba96df06df99', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'0f95034b-d607-4f84-b06d-0c2f4e679f98', N'', CAST(N'2021-10-29' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (29, N'ec1b5c5c-bab2-424e-a2a4-ba96df06df99', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'2978cd3a-0beb-4208-b1d4-6269f0a0452c', N'', CAST(N'2021-10-29' AS Date))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (30, N'ec1b5c5c-bab2-424e-a2a4-ba96df06df99', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'b4da8861-9e8d-4c9f-8dac-1cd0625ac311', N'', CAST(N'2021-10-29' AS Date))
SET IDENTITY_INSERT [dbo].[Answer] OFF
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'b266b8ef-d795-4d21-ab7a-03f8ff579626', N'5dff9795-09a3-4a59-8746-6660f6e67c3a', N'大亂鬥', 5)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'fcf1e937-dd72-4064-bbf5-0a9bf98291db', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'C#', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'0f95034b-d607-4f84-b06d-0c2f4e679f98', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'日本', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'3496d767-ac58-492a-bec5-0c3f26aacf18', N'81ecc6d2-42c3-450e-b63c-6587b4bf9fb3', N'5 年以上', 5)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'6b78c1d6-8436-48b8-87fe-1780115e92bc', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'韓國', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'b4da8861-9e8d-4c9f-8dac-1cd0625ac311', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'剛果', 7)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'879deec3-b95c-4dac-bb56-1e1ff627adf1', N'81ecc6d2-42c3-450e-b63c-6587b4bf9fb3', N'0 年', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'ae8a5d00-117f-43fe-9989-3a3e435cdfe8', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'Python', 4)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'9095fff0-fab0-4bde-8de2-59576ed2a2cf', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'Swift', 5)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'2978cd3a-0beb-4208-b1d4-6269f0a0452c', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'泰國', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'14b04308-a456-4234-ba4e-863e2735a017', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'奧地利', 5)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'3da932b9-7336-4f84-a8e1-86df607b2dc6', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'SQL', 6)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'17583b81-29c4-4c6b-ba55-87592693d392', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'Java', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'14655798-5fab-4092-a56d-8a339a954b76', N'5dff9795-09a3-4a59-8746-6660f6e67c3a', N'LOL', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'528d05d5-f7eb-49f8-a415-9183606accdd', N'81ecc6d2-42c3-450e-b63c-6587b4bf9fb3', N'1 ~ 3 年', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'cd528b5a-85a5-4a6b-9919-a2496599caa5', N'5dff9795-09a3-4a59-8746-6660f6e67c3a', N'GTA', 4)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'e7ca9da4-0fa4-4402-8a10-ba5bc2b5bbd4', N'5dff9795-09a3-4a59-8746-6660f6e67c3a', N'薩爾達傳說', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'db5534ba-2a00-4e7c-a519-bb5bee09dcc3', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'芬蘭', 6)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'1164355d-b3e8-47f0-ae76-c314e77de73b', N'81ecc6d2-42c3-450e-b63c-6587b4bf9fb3', N'3 ~ 5 年', 4)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'5322f39f-3834-4fc0-851c-c6e59c2e4d63', N'5dff9795-09a3-4a59-8746-6660f6e67c3a', N'楓之谷', 6)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'bd181019-e37e-4eb8-9307-db1c49fc90d8', N'81ecc6d2-42c3-450e-b63c-6587b4bf9fb3', N'0 ~ 1 年', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'bd1d9b93-6a70-4eb8-853b-f49ecac23733', N'5dff9795-09a3-4a59-8746-6660f6e67c3a', N'Minecraft', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'a0b50ae1-6e4b-4b43-bf1b-f6466e5f1174', N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'德國', 4)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'e233ac89-e253-47ed-982a-fac2cd4bf48e', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'JavaScript', 3)
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number]) VALUES (N'002dc1ce-9fdc-431b-aa34-0fb7d6164bcc', N'2383efec-9b1c-4c0d-9f00-6d66b9e87e6f', N'你去過以下哪些國家', 2, 1, 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number]) VALUES (N'3fd8e3fc-b72d-4b29-954d-2ed7a611cfe3', N'632612a9-3782-4d45-a72c-4fe1cf754f41', N'你玩遊戲最大的理由是?', 0, 1, 2)
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number]) VALUES (N'e21126d5-9ebf-41b8-8312-3cb898178848', N'de4af87a-6b0a-4a42-adc1-d8d0777a8130', N'你最後畢業的學校是?', 0, 0, 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number]) VALUES (N'1e0d8ab7-4012-4129-8783-51f48d2fe440', N'4ca64a1d-6f50-4fb4-a117-73113698715a', N'你最喜歡的動漫是?', 0, 0, 2)
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number]) VALUES (N'81ecc6d2-42c3-450e-b63c-6587b4bf9fb3', N'4ca64a1d-6f50-4fb4-a117-73113698715a', N'你到目前為止大約看了幾年的動漫?', 1, 0, 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number]) VALUES (N'5dff9795-09a3-4a59-8746-6660f6e67c3a', N'632612a9-3782-4d45-a72c-4fe1cf754f41', N'你玩過什麼線上遊戲?', 2, 0, 1)
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number]) VALUES (N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'92a1c74a-430e-49e9-9017-8b24c294d2f1', N'你最喜歡以下哪種程式語言?', 1, 0, 1)
INSERT [dbo].[Questionnaire] ([QuestionnaireID], [Title], [Discription], [Status], [StartDate], [EndDate]) VALUES (N'632612a9-3782-4d45-a72c-4fe1cf754f41', N'線上遊戲統計', NULL, 1, CAST(N'2021-10-20' AS Date), CAST(N'2021-11-10' AS Date))
INSERT [dbo].[Questionnaire] ([QuestionnaireID], [Title], [Discription], [Status], [StartDate], [EndDate]) VALUES (N'2383efec-9b1c-4c0d-9f00-6d66b9e87e6f', N'旅遊統計', NULL, 2, CAST(N'2021-10-05' AS Date), CAST(N'2021-10-28' AS Date))
INSERT [dbo].[Questionnaire] ([QuestionnaireID], [Title], [Discription], [Status], [StartDate], [EndDate]) VALUES (N'4ca64a1d-6f50-4fb4-a117-73113698715a', N'動漫統計', N'GUID (aka UUID) is an acronym for ''Globally Unique Identifier'' (or ''Universally Unique Identifier''). It is a 128-bit integer number used to identify resources. The term GUID is generally used by developers working with Microsoft technologies, while UUID is used everywhere else.<br>故此來做做動漫調查吧', 1, CAST(N'2021-10-18' AS Date), NULL)
INSERT [dbo].[Questionnaire] ([QuestionnaireID], [Title], [Discription], [Status], [StartDate], [EndDate]) VALUES (N'92a1c74a-430e-49e9-9017-8b24c294d2f1', N'程式語言票選', N'It is an error to use a backslash prior to any alphabetic character that does not denote an escaped construct;
        these are reserved for future extensions to the regular-expression language. A backslash may be used prior to a
        non-alphabetic character regardless of whether that character is part of an unescaped construct.
        <br>
            故此進行投票。', 1, CAST(N'2021-08-23' AS Date), CAST(N'2021-11-01' AS Date))
INSERT [dbo].[Questionnaire] ([QuestionnaireID], [Title], [Discription], [Status], [StartDate], [EndDate]) VALUES (N'de4af87a-6b0a-4a42-adc1-d8d0777a8130', N'學歷統計', NULL, 0, CAST(N'2021-11-05' AS Date), NULL)
INSERT [dbo].[Questionnaire] ([QuestionnaireID], [Title], [Discription], [Status], [StartDate], [EndDate]) VALUES (N'92d9445e-6c0a-4ae6-a7f5-f05e9b1314fe', N'古典樂調查', NULL, 3, CAST(N'2021-10-15' AS Date), NULL)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'37cb6729-4cc0-4ae9-82c4-24123ac097e8', N'John', N'0966777888', N'John@gmail.com', 30)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'5fd8da05-f12d-44cd-a33a-6452f9c80cfc', N'John', N'0966777888', N'John@nuch.edu', 26)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'9e481dd8-1a96-4ea0-b74c-9486fe6132d5', N'Peter', N'0932444566', N'ccc@hotmail.com', 11)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'ab492e72-3280-4c73-a544-9bf7ba6a0a3e', N'Peter', N'0911222333', N'peter@hotmail.com', 22)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'2b86e9c6-ae6b-409b-b79f-b22e97395745', N'John', N'0966777888', N'John@nuch.edu', 26)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'ec1b5c5c-bab2-424e-a2a4-ba96df06df99', N'Martha', N'0913444678', N'federico@yahoo.com.tw', 60)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'2eaaac13-23ec-4eea-b786-d282fa39b0d2', N'Peter', N'0911222333', N'peter@hotmail.com', 22)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'7ecb6da4-50bf-45dc-b538-deb8ed63bc54', N'Federico', N'0913444678', N'federico@yahoo.com.tw', 25)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'c64d90eb-931a-44ac-9117-ded2af2bb8bb', N'Federico', N'0913444678', N'federico@yahoo.com.tw', 26)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'2b98c0e6-2b9d-4707-938b-e825bac047d9', N'sfd', N'1111111111', N'gfd@dd', 22)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'cd42c301-971c-4824-80fa-eac0a6b2b4f2', N'Lisa', N'0912345677', N'lisa@nchu.edu.tw', 19)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'3ef53684-10ca-400a-bca1-f31f27ce22ba', N'Peter', N'0911222333', N'peter@hotmail.com', 24)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'65564652-410f-442c-b70a-f9aebe2f5f5b', N'Peter', N'0911222333', N'peter@hotmail.com', 22)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'f836390f-d4cf-476e-b6bc-fd1ab0c5757b', N'Peter', N'0911222333', N'peter@hotmail.com', 31)
ALTER TABLE [dbo].[Answer] ADD  CONSTRAINT [DF_Answer_Timestamp]  DEFAULT (getdate()) FOR [Timestamp]
GO
ALTER TABLE [dbo].[Answer]  WITH CHECK ADD  CONSTRAINT [FK_Answer_Option] FOREIGN KEY([OptionID])
REFERENCES [dbo].[Option] ([OptionID])
GO
ALTER TABLE [dbo].[Answer] CHECK CONSTRAINT [FK_Answer_Option]
GO
ALTER TABLE [dbo].[Answer]  WITH CHECK ADD  CONSTRAINT [FK_Answer_Question] FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Question] ([QuestionID])
GO
ALTER TABLE [dbo].[Answer] CHECK CONSTRAINT [FK_Answer_Question]
GO
ALTER TABLE [dbo].[Answer]  WITH CHECK ADD  CONSTRAINT [FK_Answer_Voter] FOREIGN KEY([VoterID])
REFERENCES [dbo].[Voter] ([VoterID])
GO
ALTER TABLE [dbo].[Answer] CHECK CONSTRAINT [FK_Answer_Voter]
GO
ALTER TABLE [dbo].[Option]  WITH CHECK ADD  CONSTRAINT [FK_Option_Question] FOREIGN KEY([QuestionID])
REFERENCES [dbo].[Question] ([QuestionID])
GO
ALTER TABLE [dbo].[Option] CHECK CONSTRAINT [FK_Option_Question]
GO
ALTER TABLE [dbo].[Question]  WITH CHECK ADD  CONSTRAINT [FK_Question_Questionnaire] FOREIGN KEY([QuestionnaireID])
REFERENCES [dbo].[Questionnaire] ([QuestionnaireID])
GO
ALTER TABLE [dbo].[Question] CHECK CONSTRAINT [FK_Question_Questionnaire]
GO
USE [master]
GO
ALTER DATABASE [Questionnaire] SET  READ_WRITE 
GO
