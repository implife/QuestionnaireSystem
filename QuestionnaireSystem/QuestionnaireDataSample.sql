USE [master]
GO
/****** Object:  Database [Questionnaire]    Script Date: 11/17/2021 8:44:18 AM ******/
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
/****** Object:  Table [dbo].[Answer]    Script Date: 11/17/2021 8:44:18 AM ******/
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
	[Timestamp] [datetime] NOT NULL,
 CONSTRAINT [PK_Answer] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Option]    Script Date: 11/17/2021 8:44:18 AM ******/
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
/****** Object:  Table [dbo].[Question]    Script Date: 11/17/2021 8:44:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Question](
	[QuestionID] [uniqueidentifier] NOT NULL,
	[QuestionnaireID] [uniqueidentifier] NULL,
	[Title] [nvarchar](max) NOT NULL,
	[Type] [int] NOT NULL,
	[Required] [int] NOT NULL,
	[Number] [int] NOT NULL,
	[FAQName] [nvarchar](max) NULL,
 CONSTRAINT [PK_Question] PRIMARY KEY CLUSTERED 
(
	[QuestionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Questionnaire]    Script Date: 11/17/2021 8:44:18 AM ******/
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
/****** Object:  Table [dbo].[UserInfo]    Script Date: 11/17/2021 8:44:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[UserInfo](
	[UserID] [uniqueidentifier] NOT NULL,
	[Account] [varchar](50) NOT NULL,
	[PWD] [varchar](50) NOT NULL,
	[Name] [nvarchar](50) NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[Phone] [varchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Voter]    Script Date: 11/17/2021 8:44:18 AM ******/
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

INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (2, N'65564652-410f-442c-b70a-f9aebe2f5f5b', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'ae8a5d00-117f-43fe-9989-3a3e435cdfe8', N'', CAST(N'2021-10-27 00:00:00.000' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (7, N'2eaaac13-23ec-4eea-b786-d282fa39b0d2', N'81ecc6d2-42c3-450e-b63c-6587b4bf9fb3', N'528d05d5-f7eb-49f8-a415-9183606accdd', N'', CAST(N'2021-10-27 00:00:00.000' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (9, N'37cb6729-4cc0-4ae9-82c4-24123ac097e8', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'17583b81-29c4-4c6b-ba55-87592693d392', N'', CAST(N'2021-10-28 00:00:00.000' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (10, N'c64d90eb-931a-44ac-9117-ded2af2bb8bb', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'3da932b9-7336-4f84-a8e1-86df607b2dc6', N'', CAST(N'2021-10-28 00:00:00.000' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (11, N'f836390f-d4cf-476e-b6bc-fd1ab0c5757b', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'9095fff0-fab0-4bde-8de2-59576ed2a2cf', N'', CAST(N'2021-10-28 00:00:00.000' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (12, N'3ef53684-10ca-400a-bca1-f31f27ce22ba', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'17583b81-29c4-4c6b-ba55-87592693d392', N'', CAST(N'2021-10-28 00:00:00.000' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (13, N'cd42c301-971c-4824-80fa-eac0a6b2b4f2', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'e233ac89-e253-47ed-982a-fac2cd4bf48e', N'', CAST(N'2021-10-28 00:00:00.000' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (31, N'58cd34d8-08e2-437a-9d84-6006a4940a64', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'9c12e1d1-8e2a-4b6f-8914-b6d8a0237ac1', N'', CAST(N'2021-11-09 00:00:00.000' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (32, N'58cd34d8-08e2-437a-9d84-6006a4940a64', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'65ce505a-ab06-47d4-b3f7-d32fc3bea91e', N'', CAST(N'2021-11-09 00:00:00.000' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (33, N'58cd34d8-08e2-437a-9d84-6006a4940a64', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'3c9c40e6-97a1-4a1b-87b3-e80a53e6914b', N'', CAST(N'2021-11-09 00:00:00.000' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (34, N'58cd34d8-08e2-437a-9d84-6006a4940a64', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'f766e22e-44d5-4b26-b044-e817acbfa6d3', N'', CAST(N'2021-11-09 00:00:00.000' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (35, N'58cd34d8-08e2-437a-9d84-6006a4940a64', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'd356d02d-6c09-44ed-bde8-303257d7bcc7', N'', CAST(N'2021-11-09 00:00:00.000' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (36, N'58cd34d8-08e2-437a-9d84-6006a4940a64', N'09398054-cc5a-4676-932d-b915a20f0a83', NULL, N'北海道', CAST(N'2021-11-09 00:00:00.000' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (37, N'c4551845-83a4-407a-951d-f02045661a2e', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'37b65ab4-aa7d-4632-b115-4e85fb87d0ab', N'', CAST(N'2021-11-09 20:36:14.133' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (38, N'c4551845-83a4-407a-951d-f02045661a2e', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'd319dec9-cb82-4a1c-8cd3-c6c40295a7c0', N'', CAST(N'2021-11-09 20:36:14.143' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (40, N'c4551845-83a4-407a-951d-f02045661a2e', N'09398054-cc5a-4676-932d-b915a20f0a83', NULL, N'愛知県', CAST(N'2021-11-09 20:36:14.150' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (41, N'637912ad-60ab-4d3d-b311-93eaee67d570', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'e2b2daf0-0195-45ce-af1d-f71d438c0908', N'', CAST(N'2021-11-09 20:37:31.613' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (42, N'637912ad-60ab-4d3d-b311-93eaee67d570', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'8f4f057f-1c5d-46e4-b219-be4c775fed10', N'', CAST(N'2021-11-09 20:37:31.623' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (43, N'637912ad-60ab-4d3d-b311-93eaee67d570', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'ebe346a0-0082-44f0-8453-e225da2ff9b8', N'', CAST(N'2021-11-09 20:37:31.630' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (44, N'637912ad-60ab-4d3d-b311-93eaee67d570', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'3c9c40e6-97a1-4a1b-87b3-e80a53e6914b', N'', CAST(N'2021-11-09 20:37:31.630' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (45, N'637912ad-60ab-4d3d-b311-93eaee67d570', N'09398054-cc5a-4676-932d-b915a20f0a83', NULL, N'', CAST(N'2021-11-09 20:37:31.630' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (46, N'2b9ac716-7f55-497a-98a1-28f648b76509', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'a7493e97-d195-4263-8f20-2443ef3ba04a', N'', CAST(N'2021-11-09 20:38:08.493' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (47, N'2b9ac716-7f55-497a-98a1-28f648b76509', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'bb5d8971-28e3-45d1-8438-ff8aafe07411', N'', CAST(N'2021-11-09 20:38:08.497' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (48, N'2b9ac716-7f55-497a-98a1-28f648b76509', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'ebe346a0-0082-44f0-8453-e225da2ff9b8', N'', CAST(N'2021-11-09 20:38:08.513' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (49, N'2b9ac716-7f55-497a-98a1-28f648b76509', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'8a9ea069-c0e8-4b45-a5f8-6acab387aa92', N'', CAST(N'2021-11-09 20:38:08.513' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (50, N'2b9ac716-7f55-497a-98a1-28f648b76509', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'3c9c40e6-97a1-4a1b-87b3-e80a53e6914b', N'', CAST(N'2021-11-09 20:38:08.513' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (51, N'2b9ac716-7f55-497a-98a1-28f648b76509', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'f766e22e-44d5-4b26-b044-e817acbfa6d3', N'', CAST(N'2021-11-09 20:38:08.513' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (52, N'2b9ac716-7f55-497a-98a1-28f648b76509', N'09398054-cc5a-4676-932d-b915a20f0a83', NULL, N'東京', CAST(N'2021-11-09 20:38:08.517' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (53, N'a0100c87-8984-4a35-a21d-1179a93f0413', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'9c12e1d1-8e2a-4b6f-8914-b6d8a0237ac1', N'', CAST(N'2021-11-09 20:42:42.740' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (54, N'a0100c87-8984-4a35-a21d-1179a93f0413', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'83f0cb48-b7b9-4156-abd1-e867773a1b06', N'', CAST(N'2021-11-09 20:42:42.747' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (55, N'a0100c87-8984-4a35-a21d-1179a93f0413', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'59023d46-ea62-4103-ab3e-c135261e9e95', N'', CAST(N'2021-11-09 20:42:42.753' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (56, N'a0100c87-8984-4a35-a21d-1179a93f0413', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'3aea6cd8-0620-4138-b430-c0740ce18f4f', N'', CAST(N'2021-11-09 20:42:42.753' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (57, N'a0100c87-8984-4a35-a21d-1179a93f0413', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'd356d02d-6c09-44ed-bde8-303257d7bcc7', N'', CAST(N'2021-11-09 20:42:42.753' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (58, N'a0100c87-8984-4a35-a21d-1179a93f0413', N'09398054-cc5a-4676-932d-b915a20f0a83', NULL, N'栃木県', CAST(N'2021-11-09 20:42:42.757' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (59, N'634a579f-ca3f-4fbe-a2e3-22bd797ed068', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'325f14e9-08d2-44f1-8466-02bdb928b014', N'', CAST(N'2021-11-09 20:44:20.420' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (60, N'634a579f-ca3f-4fbe-a2e3-22bd797ed068', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'65ce505a-ab06-47d4-b3f7-d32fc3bea91e', N'', CAST(N'2021-11-09 20:44:20.423' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (61, N'634a579f-ca3f-4fbe-a2e3-22bd797ed068', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'ebe346a0-0082-44f0-8453-e225da2ff9b8', N'', CAST(N'2021-11-09 20:44:20.433' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (62, N'634a579f-ca3f-4fbe-a2e3-22bd797ed068', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'3c9c40e6-97a1-4a1b-87b3-e80a53e6914b', N'', CAST(N'2021-11-09 20:44:20.433' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (63, N'634a579f-ca3f-4fbe-a2e3-22bd797ed068', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'f766e22e-44d5-4b26-b044-e817acbfa6d3', N'', CAST(N'2021-11-09 20:44:20.433' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (64, N'634a579f-ca3f-4fbe-a2e3-22bd797ed068', N'09398054-cc5a-4676-932d-b915a20f0a83', NULL, N'NO', CAST(N'2021-11-09 20:44:20.437' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (65, N'f39d86ee-a322-4cd0-8261-3ba08d7ae558', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'325f14e9-08d2-44f1-8466-02bdb928b014', N'', CAST(N'2021-11-09 20:45:28.970' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (66, N'f39d86ee-a322-4cd0-8261-3ba08d7ae558', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'bb5d8971-28e3-45d1-8438-ff8aafe07411', N'', CAST(N'2021-11-09 20:45:28.977' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (67, N'f39d86ee-a322-4cd0-8261-3ba08d7ae558', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'2b698e14-ec25-46b0-86f3-6a421fc27132', N'', CAST(N'2021-11-09 20:45:28.983' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (68, N'f39d86ee-a322-4cd0-8261-3ba08d7ae558', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'8a9ea069-c0e8-4b45-a5f8-6acab387aa92', N'', CAST(N'2021-11-09 20:45:28.983' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (69, N'f39d86ee-a322-4cd0-8261-3ba08d7ae558', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'd356d02d-6c09-44ed-bde8-303257d7bcc7', N'', CAST(N'2021-11-09 20:45:28.983' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (70, N'f39d86ee-a322-4cd0-8261-3ba08d7ae558', N'09398054-cc5a-4676-932d-b915a20f0a83', NULL, N'熊本', CAST(N'2021-11-09 20:45:28.987' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (71, N'f3c9e319-a91d-489a-a802-a38c5b984577', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'e2b2daf0-0195-45ce-af1d-f71d438c0908', N'', CAST(N'2021-11-09 20:46:33.610' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (72, N'f3c9e319-a91d-489a-a802-a38c5b984577', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'8f4f057f-1c5d-46e4-b219-be4c775fed10', N'', CAST(N'2021-11-09 20:46:33.613' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (73, N'f3c9e319-a91d-489a-a802-a38c5b984577', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'3c9c40e6-97a1-4a1b-87b3-e80a53e6914b', N'', CAST(N'2021-11-09 20:46:33.620' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (74, N'f3c9e319-a91d-489a-a802-a38c5b984577', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'd356d02d-6c09-44ed-bde8-303257d7bcc7', N'', CAST(N'2021-11-09 20:46:33.620' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (75, N'f3c9e319-a91d-489a-a802-a38c5b984577', N'09398054-cc5a-4676-932d-b915a20f0a83', NULL, N'京都', CAST(N'2021-11-09 20:46:33.623' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (76, N'd694d41d-5643-4f8b-9b6c-4fbc8f51d4be', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'e933908e-3925-4bd1-a1db-ba2803deede7', N'', CAST(N'2021-11-09 20:48:30.880' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (77, N'd694d41d-5643-4f8b-9b6c-4fbc8f51d4be', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'65ce505a-ab06-47d4-b3f7-d32fc3bea91e', N'', CAST(N'2021-11-09 20:48:30.887' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (78, N'd694d41d-5643-4f8b-9b6c-4fbc8f51d4be', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'2b698e14-ec25-46b0-86f3-6a421fc27132', N'', CAST(N'2021-11-09 20:48:30.897' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (79, N'd694d41d-5643-4f8b-9b6c-4fbc8f51d4be', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'8a9ea069-c0e8-4b45-a5f8-6acab387aa92', N'', CAST(N'2021-11-09 20:48:30.897' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (80, N'd694d41d-5643-4f8b-9b6c-4fbc8f51d4be', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'59023d46-ea62-4103-ab3e-c135261e9e95', N'', CAST(N'2021-11-09 20:48:30.897' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (81, N'd694d41d-5643-4f8b-9b6c-4fbc8f51d4be', N'09398054-cc5a-4676-932d-b915a20f0a83', NULL, N'', CAST(N'2021-11-09 20:48:30.897' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (82, N'ce518761-b2ee-4399-b646-fe679c81e175', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'a7493e97-d195-4263-8f20-2443ef3ba04a', N'', CAST(N'2021-11-09 20:49:56.707' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (83, N'ce518761-b2ee-4399-b646-fe679c81e175', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'83f0cb48-b7b9-4156-abd1-e867773a1b06', N'', CAST(N'2021-11-09 20:49:56.710' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (84, N'ce518761-b2ee-4399-b646-fe679c81e175', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'ebe346a0-0082-44f0-8453-e225da2ff9b8', N'', CAST(N'2021-11-09 20:49:56.717' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (85, N'ce518761-b2ee-4399-b646-fe679c81e175', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'59023d46-ea62-4103-ab3e-c135261e9e95', N'', CAST(N'2021-11-09 20:49:56.717' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (86, N'ce518761-b2ee-4399-b646-fe679c81e175', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'3aea6cd8-0620-4138-b430-c0740ce18f4f', N'', CAST(N'2021-11-09 20:49:56.717' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (87, N'ce518761-b2ee-4399-b646-fe679c81e175', N'09398054-cc5a-4676-932d-b915a20f0a83', NULL, N'秋田', CAST(N'2021-11-09 20:49:56.727' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (88, N'd77eb7da-3cbb-4f70-ae83-5d810fb9e200', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'e2b2daf0-0195-45ce-af1d-f71d438c0908', N'', CAST(N'2021-11-09 20:51:03.830' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (89, N'd77eb7da-3cbb-4f70-ae83-5d810fb9e200', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'8f4f057f-1c5d-46e4-b219-be4c775fed10', N'', CAST(N'2021-11-09 20:51:03.833' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (90, N'd77eb7da-3cbb-4f70-ae83-5d810fb9e200', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'3c9c40e6-97a1-4a1b-87b3-e80a53e6914b', N'', CAST(N'2021-11-09 20:51:03.843' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (91, N'd77eb7da-3cbb-4f70-ae83-5d810fb9e200', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'f766e22e-44d5-4b26-b044-e817acbfa6d3', N'', CAST(N'2021-11-09 20:51:03.843' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (92, N'd77eb7da-3cbb-4f70-ae83-5d810fb9e200', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'd356d02d-6c09-44ed-bde8-303257d7bcc7', N'', CAST(N'2021-11-09 20:51:03.843' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (93, N'd77eb7da-3cbb-4f70-ae83-5d810fb9e200', N'09398054-cc5a-4676-932d-b915a20f0a83', NULL, N'德島縣', CAST(N'2021-11-09 20:51:03.847' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (94, N'41640deb-06fc-419e-8b5e-bc8c624747ea', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'37b65ab4-aa7d-4632-b115-4e85fb87d0ab', N'', CAST(N'2021-11-09 20:52:28.513' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (95, N'41640deb-06fc-419e-8b5e-bc8c624747ea', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'8f4f057f-1c5d-46e4-b219-be4c775fed10', N'', CAST(N'2021-11-09 20:52:28.520' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (96, N'41640deb-06fc-419e-8b5e-bc8c624747ea', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'ebe346a0-0082-44f0-8453-e225da2ff9b8', N'', CAST(N'2021-11-09 20:52:28.527' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (97, N'41640deb-06fc-419e-8b5e-bc8c624747ea', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'59023d46-ea62-4103-ab3e-c135261e9e95', N'', CAST(N'2021-11-09 20:52:28.527' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (98, N'41640deb-06fc-419e-8b5e-bc8c624747ea', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'd356d02d-6c09-44ed-bde8-303257d7bcc7', N'', CAST(N'2021-11-09 20:52:28.527' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (99, N'41640deb-06fc-419e-8b5e-bc8c624747ea', N'09398054-cc5a-4676-932d-b915a20f0a83', NULL, N'パラディ島', CAST(N'2021-11-09 20:52:28.530' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (100, N'15e933ef-2a88-45c5-a60a-09678bca180c', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'37b65ab4-aa7d-4632-b115-4e85fb87d0ab', N'', CAST(N'2021-11-10 16:41:22.600' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (101, N'15e933ef-2a88-45c5-a60a-09678bca180c', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'd319dec9-cb82-4a1c-8cd3-c6c40295a7c0', N'', CAST(N'2021-11-10 16:41:22.617' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (103, N'15e933ef-2a88-45c5-a60a-09678bca180c', N'09398054-cc5a-4676-932d-b915a20f0a83', NULL, N'大阪', CAST(N'2021-11-10 16:41:22.623' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (104, N'239cf9a5-af99-44b2-bccb-4d43cc5d6238', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'37b65ab4-aa7d-4632-b115-4e85fb87d0ab', N'', CAST(N'2021-11-10 16:45:31.563' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (105, N'239cf9a5-af99-44b2-bccb-4d43cc5d6238', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'd319dec9-cb82-4a1c-8cd3-c6c40295a7c0', N'', CAST(N'2021-11-10 16:45:31.577' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (106, N'239cf9a5-af99-44b2-bccb-4d43cc5d6238', N'09398054-cc5a-4676-932d-b915a20f0a83', NULL, N'', CAST(N'2021-11-10 16:45:31.580' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (119, N'358efcde-13ea-4db0-90a1-90e4203d9d09', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'fcf1e937-dd72-4064-bbf5-0a9bf98291db', N'', CAST(N'2021-11-16 13:37:03.163' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (120, N'bb6048b3-7160-4105-8168-88d68ef06acd', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'f435d501-06d7-469c-9201-afc2c80f876b', N'', CAST(N'2021-11-16 16:57:33.390' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (121, N'bb6048b3-7160-4105-8168-88d68ef06acd', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'7b3aeeb5-fc95-411b-bc93-52f63face900', N'', CAST(N'2021-11-16 16:57:33.390' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (122, N'bb6048b3-7160-4105-8168-88d68ef06acd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'c4a22d53-9132-4985-89e8-26b4737adf2b', N'', CAST(N'2021-11-16 16:57:33.417' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (123, N'bb6048b3-7160-4105-8168-88d68ef06acd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'babe8c2f-70ca-4383-9699-533c5357def1', N'', CAST(N'2021-11-16 16:57:33.417' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (124, N'bb6048b3-7160-4105-8168-88d68ef06acd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'4b73d398-c703-4801-a4f9-f0c590347310', N'', CAST(N'2021-11-16 16:57:33.417' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (125, N'bb6048b3-7160-4105-8168-88d68ef06acd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'4c2d8c87-3c9f-46c5-8545-311dbc54ae07', N'', CAST(N'2021-11-16 16:57:33.417' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (126, N'bb6048b3-7160-4105-8168-88d68ef06acd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'f4f1cf0c-1406-48a2-a616-0d3d132a73ab', N'', CAST(N'2021-11-16 16:57:33.417' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (127, N'bb6048b3-7160-4105-8168-88d68ef06acd', N'328f43ae-e5fb-4168-b7da-16ed78d34246', NULL, N'', CAST(N'2021-11-16 16:57:33.430' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (128, N'3592d479-32aa-4452-a745-83f8d997aafd', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'5a874551-1c03-42fd-b25e-20bb6ed0bce7', N'', CAST(N'2021-11-16 17:15:56.003' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (129, N'3592d479-32aa-4452-a745-83f8d997aafd', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'f435d501-06d7-469c-9201-afc2c80f876b', N'', CAST(N'2021-11-16 17:15:56.003' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (130, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'8c325b70-feaa-421a-8a4c-273abe786481', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (131, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'c4a22d53-9132-4985-89e8-26b4737adf2b', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (132, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'331d285d-46bb-44c8-92fe-771757db9689', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (133, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'babe8c2f-70ca-4383-9699-533c5357def1', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (134, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'1b57955a-9966-4d04-b295-989480ab6370', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (135, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'4b73d398-c703-4801-a4f9-f0c590347310', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (136, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'e32dd28a-f181-4e18-b6db-6eafc797a2ba', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
GO
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (137, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'6aeaafc3-6bf0-450e-8f81-bf3e95b8d9e5', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (138, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'e09c54fa-5f63-418a-9230-2c0a8dcaa0f3', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (139, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'4c2d8c87-3c9f-46c5-8545-311dbc54ae07', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (140, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'5cc6416d-6be1-4b12-82b2-7c600552f915', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (141, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'8f87a625-571a-40e5-88d5-6606d62eea72', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (142, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'61442f72-803a-4c7a-ba29-de215462f93a', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (143, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'cf40ef39-706e-4d27-bbce-89cfefb1e66d', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (144, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'8f1a1e79-62af-46e6-8132-c6b0252c2aaf', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (145, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'f4f1cf0c-1406-48a2-a616-0d3d132a73ab', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (146, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'e82f63e9-03bb-40b1-9ab6-eb109084ddd8', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (147, N'3592d479-32aa-4452-a745-83f8d997aafd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'92a76aaf-f9ba-406f-9cb5-3b6eab88cb8f', N'', CAST(N'2021-11-16 17:15:56.043' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (148, N'3592d479-32aa-4452-a745-83f8d997aafd', N'328f43ae-e5fb-4168-b7da-16ed78d34246', NULL, N'Mahler Symphony No.2', CAST(N'2021-11-16 17:15:56.053' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (149, N'749854b3-98ef-4d1b-a9dc-d7f5e4b2f9bf', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'5a874551-1c03-42fd-b25e-20bb6ed0bce7', N'', CAST(N'2021-11-16 17:17:12.623' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (150, N'749854b3-98ef-4d1b-a9dc-d7f5e4b2f9bf', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'022fb31a-e4e4-45eb-9238-b7dbdb590f12', N'', CAST(N'2021-11-16 17:17:12.623' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (151, N'749854b3-98ef-4d1b-a9dc-d7f5e4b2f9bf', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'169ba871-41f5-40f2-b555-ee88e5aebf89', N'', CAST(N'2021-11-16 17:17:12.623' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (152, N'749854b3-98ef-4d1b-a9dc-d7f5e4b2f9bf', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'8c325b70-feaa-421a-8a4c-273abe786481', N'', CAST(N'2021-11-16 17:17:12.647' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (153, N'749854b3-98ef-4d1b-a9dc-d7f5e4b2f9bf', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'c4a22d53-9132-4985-89e8-26b4737adf2b', N'', CAST(N'2021-11-16 17:17:12.647' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (154, N'749854b3-98ef-4d1b-a9dc-d7f5e4b2f9bf', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'babe8c2f-70ca-4383-9699-533c5357def1', N'', CAST(N'2021-11-16 17:17:12.647' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (155, N'749854b3-98ef-4d1b-a9dc-d7f5e4b2f9bf', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'4b73d398-c703-4801-a4f9-f0c590347310', N'', CAST(N'2021-11-16 17:17:12.647' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (156, N'749854b3-98ef-4d1b-a9dc-d7f5e4b2f9bf', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'e32dd28a-f181-4e18-b6db-6eafc797a2ba', N'', CAST(N'2021-11-16 17:17:12.647' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (157, N'749854b3-98ef-4d1b-a9dc-d7f5e4b2f9bf', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'4c2d8c87-3c9f-46c5-8545-311dbc54ae07', N'', CAST(N'2021-11-16 17:17:12.647' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (158, N'749854b3-98ef-4d1b-a9dc-d7f5e4b2f9bf', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'61442f72-803a-4c7a-ba29-de215462f93a', N'', CAST(N'2021-11-16 17:17:12.647' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (159, N'749854b3-98ef-4d1b-a9dc-d7f5e4b2f9bf', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'92a76aaf-f9ba-406f-9cb5-3b6eab88cb8f', N'', CAST(N'2021-11-16 17:17:12.647' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (160, N'749854b3-98ef-4d1b-a9dc-d7f5e4b2f9bf', N'328f43ae-e5fb-4168-b7da-16ed78d34246', NULL, N'魔笛', CAST(N'2021-11-16 17:17:12.650' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (161, N'b2809a65-a980-4d16-b163-8c145439f59f', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'f435d501-06d7-469c-9201-afc2c80f876b', N'', CAST(N'2021-11-16 17:21:10.237' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (162, N'b2809a65-a980-4d16-b163-8c145439f59f', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'c57cda98-5637-46f3-abed-76e3a637b23e', N'', CAST(N'2021-11-16 17:21:10.237' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (163, N'b2809a65-a980-4d16-b163-8c145439f59f', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'c4a22d53-9132-4985-89e8-26b4737adf2b', N'', CAST(N'2021-11-16 17:21:10.253' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (164, N'b2809a65-a980-4d16-b163-8c145439f59f', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'babe8c2f-70ca-4383-9699-533c5357def1', N'', CAST(N'2021-11-16 17:21:10.253' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (165, N'b2809a65-a980-4d16-b163-8c145439f59f', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'4b73d398-c703-4801-a4f9-f0c590347310', N'', CAST(N'2021-11-16 17:21:10.253' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (166, N'b2809a65-a980-4d16-b163-8c145439f59f', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'4c2d8c87-3c9f-46c5-8545-311dbc54ae07', N'', CAST(N'2021-11-16 17:21:10.253' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (167, N'b2809a65-a980-4d16-b163-8c145439f59f', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'8f1a1e79-62af-46e6-8132-c6b0252c2aaf', N'', CAST(N'2021-11-16 17:21:10.253' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (168, N'b2809a65-a980-4d16-b163-8c145439f59f', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'ef7966c6-93da-426f-b852-2b321a5296f2', N'', CAST(N'2021-11-16 17:21:10.253' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (169, N'b2809a65-a980-4d16-b163-8c145439f59f', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'92a76aaf-f9ba-406f-9cb5-3b6eab88cb8f', N'', CAST(N'2021-11-16 17:21:10.253' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (170, N'b2809a65-a980-4d16-b163-8c145439f59f', N'328f43ae-e5fb-4168-b7da-16ed78d34246', NULL, N'貝多芬 英雄交響曲', CAST(N'2021-11-16 17:21:10.257' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (171, N'f949fbbc-2d22-4589-8cba-d00478602414', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'5a874551-1c03-42fd-b25e-20bb6ed0bce7', N'', CAST(N'2021-11-16 17:22:50.530' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (172, N'f949fbbc-2d22-4589-8cba-d00478602414', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'7b3aeeb5-fc95-411b-bc93-52f63face900', N'', CAST(N'2021-11-16 17:22:50.530' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (173, N'f949fbbc-2d22-4589-8cba-d00478602414', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'8c325b70-feaa-421a-8a4c-273abe786481', N'', CAST(N'2021-11-16 17:22:50.553' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (174, N'f949fbbc-2d22-4589-8cba-d00478602414', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'c4a22d53-9132-4985-89e8-26b4737adf2b', N'', CAST(N'2021-11-16 17:22:50.553' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (175, N'f949fbbc-2d22-4589-8cba-d00478602414', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'331d285d-46bb-44c8-92fe-771757db9689', N'', CAST(N'2021-11-16 17:22:50.553' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (176, N'f949fbbc-2d22-4589-8cba-d00478602414', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'babe8c2f-70ca-4383-9699-533c5357def1', N'', CAST(N'2021-11-16 17:22:50.553' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (177, N'f949fbbc-2d22-4589-8cba-d00478602414', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'4b73d398-c703-4801-a4f9-f0c590347310', N'', CAST(N'2021-11-16 17:22:50.553' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (178, N'f949fbbc-2d22-4589-8cba-d00478602414', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'e32dd28a-f181-4e18-b6db-6eafc797a2ba', N'', CAST(N'2021-11-16 17:22:50.553' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (179, N'f949fbbc-2d22-4589-8cba-d00478602414', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'e09c54fa-5f63-418a-9230-2c0a8dcaa0f3', N'', CAST(N'2021-11-16 17:22:50.553' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (180, N'f949fbbc-2d22-4589-8cba-d00478602414', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'4c2d8c87-3c9f-46c5-8545-311dbc54ae07', N'', CAST(N'2021-11-16 17:22:50.553' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (181, N'f949fbbc-2d22-4589-8cba-d00478602414', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'cf40ef39-706e-4d27-bbce-89cfefb1e66d', N'', CAST(N'2021-11-16 17:22:50.553' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (182, N'f949fbbc-2d22-4589-8cba-d00478602414', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'8f1a1e79-62af-46e6-8132-c6b0252c2aaf', N'', CAST(N'2021-11-16 17:22:50.553' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (183, N'f949fbbc-2d22-4589-8cba-d00478602414', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'e82f63e9-03bb-40b1-9ab6-eb109084ddd8', N'', CAST(N'2021-11-16 17:22:50.553' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (184, N'f949fbbc-2d22-4589-8cba-d00478602414', N'328f43ae-e5fb-4168-b7da-16ed78d34246', NULL, N'', CAST(N'2021-11-16 17:22:50.560' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (185, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'5a874551-1c03-42fd-b25e-20bb6ed0bce7', N'', CAST(N'2021-11-16 17:24:43.130' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (186, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'8c325b70-feaa-421a-8a4c-273abe786481', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (187, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'c4a22d53-9132-4985-89e8-26b4737adf2b', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (188, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'331d285d-46bb-44c8-92fe-771757db9689', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (189, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'babe8c2f-70ca-4383-9699-533c5357def1', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (190, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'1b57955a-9966-4d04-b295-989480ab6370', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (191, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'4b73d398-c703-4801-a4f9-f0c590347310', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (192, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'e32dd28a-f181-4e18-b6db-6eafc797a2ba', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (193, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'6aeaafc3-6bf0-450e-8f81-bf3e95b8d9e5', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (194, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'be34403f-04bc-4c82-a3ef-0b61af1c59a4', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (195, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'd0fa700c-773e-4b6e-8209-eafdfbb2aab3', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (196, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'e09c54fa-5f63-418a-9230-2c0a8dcaa0f3', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (197, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'4c2d8c87-3c9f-46c5-8545-311dbc54ae07', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (198, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'5cc6416d-6be1-4b12-82b2-7c600552f915', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (199, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'8f87a625-571a-40e5-88d5-6606d62eea72', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (200, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'61442f72-803a-4c7a-ba29-de215462f93a', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (201, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'cf40ef39-706e-4d27-bbce-89cfefb1e66d', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (202, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'8f1a1e79-62af-46e6-8132-c6b0252c2aaf', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (203, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'f4f1cf0c-1406-48a2-a616-0d3d132a73ab', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (204, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'ef7966c6-93da-426f-b852-2b321a5296f2', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (205, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'e82f63e9-03bb-40b1-9ab6-eb109084ddd8', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (206, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'3055bf3a-59f5-4d28-8c8c-3182a7c3e1c7', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (207, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'ec86fb71-5da4-4c8a-9847-80ba051e2262', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (208, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'92a76aaf-f9ba-406f-9cb5-3b6eab88cb8f', N'', CAST(N'2021-11-16 17:24:43.170' AS DateTime))
INSERT [dbo].[Answer] ([ID], [VoterID], [QuestionID], [OptionID], [TextboxContent], [Timestamp]) VALUES (209, N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'328f43ae-e5fb-4168-b7da-16ed78d34246', NULL, N'舒伯特 冬之旅', CAST(N'2021-11-16 17:24:43.180' AS DateTime))
SET IDENTITY_INSERT [dbo].[Answer] OFF
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'325f14e9-08d2-44f1-8466-02bdb928b014', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'N3', 4)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'f1e3f126-d3e7-4f3b-ba3d-043dbba05cc5', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'推理懸疑', 15)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'08b69877-4740-49bd-86f4-0709c902fb3c', N'ea27f2b1-1eb8-4abc-aeff-eafc66f982e2', N'跨性別', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'fcf1e937-dd72-4064-bbf5-0a9bf98291db', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'C#', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'be34403f-04bc-4c82-a3ef-0b61af1c59a4', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'霍爾斯特', 11)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'3496d767-ac58-492a-bec5-0c3f26aacf18', N'81ecc6d2-42c3-450e-b63c-6587b4bf9fb3', N'5 年以上', 5)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'f4f1cf0c-1406-48a2-a616-0d3d132a73ab', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'布拉姆斯', 20)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'9311f252-c621-4b1f-a1f5-0f3133cdf015', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'職場', 14)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'e8b1db1d-e912-4138-b4c1-1aae990785c2', N'fdf8ef24-ab66-4e64-aa71-715c81a490b4', N'偶爾買一下', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'879deec3-b95c-4dac-bb56-1e1ff627adf1', N'81ecc6d2-42c3-450e-b63c-6587b4bf9fb3', N'0 年', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'04ccedd4-4869-4430-9728-203a1e8c5c2b', N'249071c8-604e-48f5-a8e5-91042a241da0', N'大學', 4)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'5a874551-1c03-42fd-b25e-20bb6ed0bce7', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'古典', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'42fc7304-f5b9-4c5d-9604-222036fc0480', N'fdf8ef24-ab66-4e64-aa71-715c81a490b4', N'不買', 4)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'a7493e97-d195-4263-8f20-2443ef3ba04a', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'N1', 6)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'c4a22d53-9132-4985-89e8-26b4737adf2b', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'莫札特', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'8c325b70-feaa-421a-8a4c-273abe786481', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'韋瓦第', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'8a8ba9dc-4c98-41c9-8cf5-297698c94667', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'詢白克', 24)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'ef7966c6-93da-426f-b852-2b321a5296f2', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'夏布里耶', 21)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'e09c54fa-5f63-418a-9230-2c0a8dcaa0f3', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'西貝流士', 13)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'712922a1-ba41-4012-92bf-2de585658702', N'249071c8-604e-48f5-a8e5-91042a241da0', N'高中', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'd356d02d-6c09-44ed-bde8-303257d7bcc7', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'自學', 8)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'4c2d8c87-3c9f-46c5-8545-311dbc54ae07', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'舒伯特', 14)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'3055bf3a-59f5-4d28-8c8c-3182a7c3e1c7', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'蕭斯塔高維奇', 23)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'6f8b86c3-cf5d-4704-848e-32120fab6892', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'校園', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'ae8a5d00-117f-43fe-9989-3a3e435cdfe8', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'Python', 4)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'92a76aaf-f9ba-406f-9cb5-3b6eab88cb8f', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'拉赫曼尼諾夫', 27)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'4cc653e7-8044-4e91-98a4-3d0f323a24bd', N'249071c8-604e-48f5-a8e5-91042a241da0', N'碩士', 5)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'ccc43898-75e8-4e70-a6dd-422609f4c191', N'a2e8424e-3315-454b-959e-0155c34ebed5', N'跨性別', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'f8ab6c79-ed6b-4412-8a18-47bedd015fcf', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'社會/犯罪', 16)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'84a541ad-54ec-4898-89e3-49bd3ac7faa4', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'運動', 9)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'601076a4-01d1-49b8-910e-4c767310a4d2', N'249071c8-604e-48f5-a8e5-91042a241da0', N'博士', 6)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'37b65ab4-aa7d-4632-b115-4e85fb87d0ab', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'沒有', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'2b006eb7-b487-4e3b-bde7-512708c66d8d', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'熱血', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'7b3aeeb5-fc95-411b-bc93-52f63face900', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'流行音樂', 4)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'babe8c2f-70ca-4383-9699-533c5357def1', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'貝多芬', 4)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'b6e25dbf-a022-49a3-a572-565584a11ab4', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'冒險', 6)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'9095fff0-fab0-4bde-8de2-59576ed2a2cf', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'Swift', 5)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'cbc9d873-b6ba-4882-b277-5e577c6a858b', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'獵奇', 10)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'8f87a625-571a-40e5-88d5-6606d62eea72', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'克拉拉', 16)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'2b698e14-ec25-46b0-86f3-6a421fc27132', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'電視', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'8a9ea069-c0e8-4b45-a5f8-6acab387aa92', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'廣播', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'49996dd9-2566-4ed8-9fb0-6d3481f1ea80', N'ea27f2b1-1eb8-4abc-aeff-eafc66f982e2', N'女', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'e32dd28a-f181-4e18-b6db-6eafc797a2ba', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'李斯特', 7)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'cfd43afc-6025-4c7a-8f09-6fc9369c85aa', N'0e5a8a69-13b3-4114-aade-02a4eb670b1f', N'博士', 6)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'c57cda98-5637-46f3-abed-76e3a637b23e', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'重金屬', 6)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'331d285d-46bb-44c8-92fe-771757db9689', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'海頓', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'182cff3e-2fba-4ee5-97d6-7918f5cc537d', N'0e5a8a69-13b3-4114-aade-02a4eb670b1f', N'碩士', 5)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'10f5e300-29f7-4b48-b428-793fa94c2b1b', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'戰爭', 8)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'5cc6416d-6be1-4b12-82b2-7c600552f915', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'舒曼', 15)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'35fdec03-3ca7-45a6-8e4a-7d09a13431dc', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'羅西尼', 9)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'ec86fb71-5da4-4c8a-9847-80ba051e2262', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'魏本', 25)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'91f99e4b-bee6-4ab9-a2ee-86612a848cdc', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'搞笑', 5)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'3da932b9-7336-4f84-a8e1-86df607b2dc6', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'SQL', 6)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'17583b81-29c4-4c6b-ba55-87592693d392', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'Java', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'fac34fd7-725a-470a-9b83-891109ea734c', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'治愈', 11)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'cf40ef39-706e-4d27-bbce-89cfefb1e66d', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'拉威爾', 18)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'528d05d5-f7eb-49f8-a415-9183606accdd', N'81ecc6d2-42c3-450e-b63c-6587b4bf9fb3', N'1 ~ 3 年', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'73a54e20-6480-45f2-a163-920483e60133', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'康果爾德', 26)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'4ca46c63-eabd-4003-8f8f-96f74e9ecd7b', N'ea27f2b1-1eb8-4abc-aeff-eafc66f982e2', N'男', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'1b57955a-9966-4d04-b295-989480ab6370', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'布魯赫', 5)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'd982e0d8-939a-45fd-aab6-9ad960b3dbad', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'動作', 7)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'd02c13d0-441b-46e8-a6e2-9c0515aaa63a', N'fdf8ef24-ab66-4e64-aa71-715c81a490b4', N'買爆', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'64ae34e2-27f4-4851-815e-a6727bbe4ddd', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'奇幻', 4)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'6047b562-bc9b-4b8d-9cb7-a7a92ec0ac36', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'戀愛', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'f435d501-06d7-469c-9201-afc2c80f876b', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'爵士', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'b877073b-8263-4bca-9e6f-b198c3b61e87', N'0e5a8a69-13b3-4114-aade-02a4eb670b1f', N'大學', 4)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'00261631-94ba-449a-9ccf-b4b0381be0f4', N'a2e8424e-3315-454b-959e-0155c34ebed5', N'男', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'9c12e1d1-8e2a-4b6f-8914-b6d8a0237ac1', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'N2', 5)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'022fb31a-e4e4-45eb-9238-b7dbdb590f12', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'輕音樂', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'd33f604b-9e97-49aa-bc04-b89f3c034227', N'249071c8-604e-48f5-a8e5-91042a241da0', N'國小', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'e933908e-3925-4bd1-a1db-ba2803deede7', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'N4', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'53bcebce-30e6-4f30-9005-ba37ebf4395c', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'機戰', 13)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'65f17ac7-9823-475f-96ae-bac6cea28cc6', N'0e5a8a69-13b3-4114-aade-02a4eb670b1f', N'國中', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'8f4f057f-1c5d-46e4-b219-be4c775fed10', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'0 ~ 1年', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'8e618900-cc78-4393-b801-bea0e6c35738', N'249071c8-604e-48f5-a8e5-91042a241da0', N'國中', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'6aeaafc3-6bf0-450e-8f81-bf3e95b8d9e5', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'奧芬巴哈', 10)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'3aea6cd8-0620-4138-b430-c0740ce18f4f', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'補習', 7)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'59023d46-ea62-4103-ab3e-c135261e9e95', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'日本朋友', 6)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'1164355d-b3e8-47f0-ae76-c314e77de73b', N'81ecc6d2-42c3-450e-b63c-6587b4bf9fb3', N'3 ~ 5 年', 4)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'8f1a1e79-62af-46e6-8132-c6b0252c2aaf', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'馬勒', 19)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'd319dec9-cb82-4a1c-8cd3-c6c40295a7c0', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'沒學過', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'831bd0d6-bb80-4387-920e-cdbcf07d79e4', N'0e5a8a69-13b3-4114-aade-02a4eb670b1f', N'高中', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'65ce505a-ab06-47d4-b3f7-d32fc3bea91e', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'1 ~ 3年', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'bd181019-e37e-4eb8-9307-db1c49fc90d8', N'81ecc6d2-42c3-450e-b63c-6587b4bf9fb3', N'0 ~ 1 年', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'294afe6b-d435-46ed-b7c8-dd691751db14', N'fdf8ef24-ab66-4e64-aa71-715c81a490b4', N'經常吧', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'61442f72-803a-4c7a-ba29-de215462f93a', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'德布西', 17)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'c75ca2b7-1d18-4e08-89b1-deceef5c19b7', N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'勵志', 12)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'ebe346a0-0082-44f0-8453-e225da2ff9b8', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'網路', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'3c9c40e6-97a1-4a1b-87b3-e80a53e6914b', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'漫畫', 4)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'f766e22e-44d5-4b26-b044-e817acbfa6d3', N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'小說', 5)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'83f0cb48-b7b9-4156-abd1-e867773a1b06', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'3 ~ 5年', 4)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'd0fa700c-773e-4b6e-8209-eafdfbb2aab3', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'楊納傑克', 12)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'e82f63e9-03bb-40b1-9ab6-eb109084ddd8', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'華格納', 22)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'7514f0f9-d347-4174-8b60-eb396c4fcdfd', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'普契尼', 8)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'169ba871-41f5-40f2-b555-ee88e5aebf89', N'7df80034-2922-4c93-bd58-99aa8003afe7', N'音樂劇', 5)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'4b73d398-c703-4801-a4f9-f0c590347310', N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'蕭邦', 6)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'e2b2daf0-0195-45ce-af1d-f71d438c0908', N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'N5', 2)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'8fc9543d-36a5-43ba-9292-f9e7cb78e723', N'0e5a8a69-13b3-4114-aade-02a4eb670b1f', N'國小', 1)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'e233ac89-e253-47ed-982a-fac2cd4bf48e', N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'JavaScript', 3)
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'6d25d59d-3348-4985-bdef-fdb52ce0f686', N'a2e8424e-3315-454b-959e-0155c34ebed5', N'女', 2)
GO
INSERT [dbo].[Option] ([OptionID], [QuestionID], [OptionContent], [Number]) VALUES (N'bb5d8971-28e3-45d1-8438-ff8aafe07411', N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'5年以上', 5)
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'a2e8424e-3315-454b-959e-0155c34ebed5', N'de4af87a-6b0a-4a42-adc1-d8d0777a8130', N'請問你的性別是？', 1, 0, 1, N'')
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'0e5a8a69-13b3-4114-aade-02a4eb670b1f', NULL, N'請問你的最高學歷是？', 1, 0, 2, N'學歷')
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'3ccb870c-8d61-48dd-b7af-10016cc803f5', N'4ca64a1d-6f50-4fb4-a117-73113698715a', N'推薦的動漫？', 0, 1, 4, N'')
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'328f43ae-e5fb-4168-b7da-16ed78d34246', N'0ba87e28-aa17-4821-bdf4-e17793afd98a', N'推薦一個你最喜歡的古典樂吧！', 0, 1, 3, N'')
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'58d47fa2-6816-476e-ba3e-28b8919fb9fc', N'de4af87a-6b0a-4a42-adc1-d8d0777a8130', N'你是哪一間學校畢業的？', 0, 1, 3, N'')
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'28c4bf63-8fba-454f-ac13-294bb93badcb', N'4ca64a1d-6f50-4fb4-a117-73113698715a', N'你喜歡看哪些類型的動漫呢？', 2, 1, 2, N'')
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'81ecc6d2-42c3-450e-b63c-6587b4bf9fb3', N'4ca64a1d-6f50-4fb4-a117-73113698715a', N'你到目前為止大約看了幾年的動漫？', 1, 0, 1, N'')
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'fdf8ef24-ab66-4e64-aa71-715c81a490b4', N'4ca64a1d-6f50-4fb4-a117-73113698715a', N'你是會買動漫周邊的人嗎？', 1, 0, 3, N'')
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'249071c8-604e-48f5-a8e5-91042a241da0', N'de4af87a-6b0a-4a42-adc1-d8d0777a8130', N'請問你的最高學歷是？', 1, 0, 2, N'')
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'7df80034-2922-4c93-bd58-99aa8003afe7', N'0ba87e28-aa17-4821-bdf4-e17793afd98a', N'你喜歡聽什麼類型的音樂呢？', 2, 0, 1, N'')
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'53622acb-066e-4fb4-91fd-a4fa6f2a6e3e', N'0ba87e28-aa17-4821-bdf4-e17793afd98a', N'請勾選下列你聽過的音樂家。', 2, 0, 2, N'')
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'28875d78-5d67-4266-b67c-b5d8902ffe7a', N'9cb6f63e-fee6-4199-9985-9146b2eeadeb', N'目前擁有的JLPT證照', 1, 0, 1, NULL)
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'09398054-cc5a-4676-932d-b915a20f0a83', N'9cb6f63e-fee6-4199-9985-9146b2eeadeb', N'你最喜歡的日本縣市？', 0, 1, 4, NULL)
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'ed8177e1-3d73-4d1a-b0e4-bc01864022eb', N'9cb6f63e-fee6-4199-9985-9146b2eeadeb', N'你是用什麼管道學日文的呢？', 2, 1, 3, NULL)
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'ea27f2b1-1eb8-4abc-aeff-eafc66f982e2', NULL, N'請問你的性別是？', 1, 0, 1, N'性別')
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'e86af4f6-8acd-46c1-a4f3-f80fee80b1ea', N'9cb6f63e-fee6-4199-9985-9146b2eeadeb', N'到目前為止日文大概學了多久？', 1, 0, 2, NULL)
INSERT [dbo].[Question] ([QuestionID], [QuestionnaireID], [Title], [Type], [Required], [Number], [FAQName]) VALUES (N'4f70dd8d-2a88-4801-a5b0-fec7e1429ce3', N'92a1c74a-430e-49e9-9017-8b24c294d2f1', N'你最喜歡以下哪種程式語言?', 1, 0, 1, NULL)
INSERT [dbo].[Questionnaire] ([QuestionnaireID], [Title], [Discription], [Status], [StartDate], [EndDate]) VALUES (N'4ca64a1d-6f50-4fb4-a117-73113698715a', N'動漫統計', N'而日本動漫在後期，隨著電玩產業的快速崛起，自1990年代起此三項產業已緊密結合，並在日本形成一個成熟的產業鏈，許多作品企劃都作跨媒體製作以期達到最大收益。動漫已經從單單的平面媒體和電視媒體，擴展到電視遊樂器、網際網絡、玩具等許多領域。', 1, CAST(N'2021-10-18' AS Date), NULL)
INSERT [dbo].[Questionnaire] ([QuestionnaireID], [Title], [Discription], [Status], [StartDate], [EndDate]) VALUES (N'92a1c74a-430e-49e9-9017-8b24c294d2f1', N'程式語言票選', N'It is an error to use a backslash prior to any alphabetic character that does not denote an escaped construct;
        these are reserved for future extensions to the regular-expression language. A backslash may be used prior to a
        non-alphabetic character regardless of whether that character is part of an unescaped construct.
            故此進行投票。', 2, CAST(N'2021-08-23' AS Date), CAST(N'2021-11-11' AS Date))
INSERT [dbo].[Questionnaire] ([QuestionnaireID], [Title], [Discription], [Status], [StartDate], [EndDate]) VALUES (N'9cb6f63e-fee6-4199-9985-9146b2eeadeb', N'日文程度調查問卷', N'日文程度調查
請誠實填寫~~~', 2, CAST(N'2021-11-05' AS Date), CAST(N'2021-11-15' AS Date))
INSERT [dbo].[Questionnaire] ([QuestionnaireID], [Title], [Discription], [Status], [StartDate], [EndDate]) VALUES (N'de4af87a-6b0a-4a42-adc1-d8d0777a8130', N'學歷統計', N'秀一下你的學歷吧！', 1, CAST(N'2021-10-28' AS Date), CAST(N'2021-11-28' AS Date))
INSERT [dbo].[Questionnaire] ([QuestionnaireID], [Title], [Discription], [Status], [StartDate], [EndDate]) VALUES (N'0ba87e28-aa17-4821-bdf4-e17793afd98a', N'古典樂調查', N'你喜歡什麼類型的音樂呢？對古典音樂熟嗎？來測試你的音樂Sense吧！', 1, CAST(N'2021-11-10' AS Date), CAST(N'2021-12-10' AS Date))
INSERT [dbo].[UserInfo] ([UserID], [Account], [PWD], [Name], [Email], [Phone]) VALUES (N'd82705f3-01ea-4111-ab12-b5a3c254c03a', N'Kenny', N'123456', N'肯尼', N'kenny@hotmail.com', NULL)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'e3c5fa38-69b0-4584-9285-00685ecfca63', N'Peter', N'0911222333', N'peter@hotmail.com', 25)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'15e933ef-2a88-45c5-a60a-09678bca180c', N'Lily', N'0986562312', N'lily@gmail.com', 30)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'a0100c87-8984-4a35-a21d-1179a93f0413', N'王曉明', N'0932123456', N'ming@gmail.com', 26)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'634a579f-ca3f-4fbe-a2e3-22bd797ed068', N'田中アリカ', N'0987777445', N'tanaka@yahoo.com.tw', 29)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'37cb6729-4cc0-4ae9-82c4-24123ac097e8', N'John', N'0966777888', N'John@gmail.com', 30)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'2b9ac716-7f55-497a-98a1-28f648b76509', N'John', N'0966777888', N'John@nuch.edu', 50)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'f39d86ee-a322-4cd0-8261-3ba08d7ae558', N'小王', N'0984552145', N'wann@gmail.com', 80)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'239cf9a5-af99-44b2-bccb-4d43cc5d6238', N'Olivia', N'0945778632', N'olivia@yahoo.com.tw', 27)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'd694d41d-5643-4f8b-9b6c-4fbc8f51d4be', N'妙麗', N'0915468523', N'Hermione@gmail.com', 50)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'd77eb7da-3cbb-4f70-ae83-5d810fb9e200', N'Wendy', N'0963222111', N'wendy@hotmail.com', 13)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'675f31e2-70ea-4870-b56b-5f38c92139cb', N'山本五十六', N'0986541235', N'yamamoto@hotmail.com', 70)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'58cd34d8-08e2-437a-9d84-6006a4940a64', N'Peter', N'0911222333', N'peter@hotmail.com', 20)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'5fd8da05-f12d-44cd-a33a-6452f9c80cfc', N'John', N'0966777888', N'John@nuch.edu', 26)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'52092923-5b02-419c-ad6f-6753fff0c23f', N'Peter', N'0911222333', N'peter@hotmail.com', 50)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'3592d479-32aa-4452-a745-83f8d997aafd', N'Federico', N'0913444678', N'federico@yahoo.com.tw', 28)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'bb6048b3-7160-4105-8168-88d68ef06acd', N'Peter', N'0911222333', N'peter@hotmail.com', 25)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'b2809a65-a980-4d16-b163-8c145439f59f', N'John', N'0966777888', N'John@nuch.edu', 35)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'358efcde-13ea-4db0-90a1-90e4203d9d09', N'Lily', N'0986562312', N'lily@gmail.com', 30)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'637912ad-60ab-4d3d-b311-93eaee67d570', N'Federico', N'0913444678', N'federico@yahoo.com.tw', 22)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'9e481dd8-1a96-4ea0-b74c-9486fe6132d5', N'Peter', N'0932444566', N'ccc@hotmail.com', 11)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'3b8418ae-a55f-40de-a5d5-9659dbb8530f', N'Federico', N'0913444678', N'federico@yahoo.com.tw', 29)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'ab492e72-3280-4c73-a544-9bf7ba6a0a3e', N'Peter', N'0911222333', N'peter@hotmail.com', 22)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'f3c9e319-a91d-489a-a802-a38c5b984577', N'Harry', N'0981354555', N'harrypotter@hotmail.com', 39)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'2b86e9c6-ae6b-409b-b79f-b22e97395745', N'John', N'0966777888', N'John@nuch.edu', 26)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'f7c45279-c78e-4f4b-a0e2-b2bebe90c7c2', N'sfd', N'1111111111', N'gfd@dd', 30)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'ec1b5c5c-bab2-424e-a2a4-ba96df06df99', N'Martha', N'0913444678', N'federico@yahoo.com.tw', 60)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'41640deb-06fc-419e-8b5e-bc8c624747ea', N'ベルトルト', N'0960002314', N'bertolt@yahoo.com.tw', 15)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'41d8735d-efd3-4cd3-a4b4-c0dba37b1885', N'John', N'0966777888', N'John@nuch.edu', 89)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'f949fbbc-2d22-4589-8cba-d00478602414', N'大熊', N'0966583212', N'dashon@gmail.com', 26)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'2eaaac13-23ec-4eea-b786-d282fa39b0d2', N'Peter', N'0911222333', N'peter@hotmail.com', 22)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'749854b3-98ef-4d1b-a9dc-d7f5e4b2f9bf', N'Martha', N'0913444678', N'federico@yahoo.com.tw', 30)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'968dee8c-88a3-450f-9bf7-d847dfa66c0e', N'Peter', N'0911222333', N'peter@hotmail.com', 60)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'7ecb6da4-50bf-45dc-b538-deb8ed63bc54', N'Federico', N'0913444678', N'federico@yahoo.com.tw', 25)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'c64d90eb-931a-44ac-9117-ded2af2bb8bb', N'Federico', N'0913444678', N'federico@yahoo.com.tw', 26)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'2b98c0e6-2b9d-4707-938b-e825bac047d9', N'sfd', N'1111111111', N'gfd@dd', 22)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'cd42c301-971c-4824-80fa-eac0a6b2b4f2', N'Lisa', N'0912345677', N'lisa@nchu.edu.tw', 19)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'c4551845-83a4-407a-951d-f02045661a2e', N'Martha', N'0913444678', N'federico@yahoo.com.tw', 19)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'3ef53684-10ca-400a-bca1-f31f27ce22ba', N'Peter', N'0911222333', N'peter@hotmail.com', 24)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'65564652-410f-442c-b70a-f9aebe2f5f5b', N'Peter', N'0911222333', N'peter@hotmail.com', 22)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'c2ea8975-977b-475b-a7cd-fb5f9567bab9', N'John', N'0966777888', N'John@nuch.edu', 28)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'f836390f-d4cf-476e-b6bc-fd1ab0c5757b', N'Peter', N'0911222333', N'peter@hotmail.com', 31)
INSERT [dbo].[Voter] ([VoterID], [Name], [Phone], [Email], [Age]) VALUES (N'ce518761-b2ee-4399-b646-fe679c81e175', N'廖先生', N'0965844523', N'lionking@hotmail.com', 36)
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
