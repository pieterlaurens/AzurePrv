CREATE TABLE [dbo].[DIM_COMPANYLONGLIST_WEB] (
    [companyPrimKey]   VARCHAR (25)   NOT NULL,
    [companyDummyMeas] INT            NOT NULL,
    [companyName]      NVARCHAR (255) NULL,
    [a00001]           NVARCHAR (MAX) NULL,
    [a00002]           BIGINT         NULL,
    [a00003]           BIGINT         NULL,
    [a00004]           FLOAT (53)     NULL,
    [a00005]           BIGINT         NULL,
    [a00006]           NVARCHAR (MAX) NULL,
    [a00007]           NVARCHAR (MAX) NULL,
    [a00008]           NVARCHAR (MAX) NULL,
    [a00009]           NVARCHAR (MAX) NULL,
    [a00010]           FLOAT (53)     NULL,
    [a00011]           FLOAT (53)     NULL,
    [a00012]           FLOAT (53)     NULL,
    [a00013]           FLOAT (53)     NULL,
    [a00014]           BIGINT         NULL,
    [a00015]           NVARCHAR (MAX) NULL,
    [a00016]           FLOAT (53)     NULL,
    [a00017]           FLOAT (53)     NULL,
    [a00018]           FLOAT (53)     NULL,
    [a00019]           FLOAT (53)     NULL,
    [a00020]           FLOAT (53)     NULL,
    [a00021]           FLOAT (53)     NULL,
    [a00022]           FLOAT (53)     NULL,
    [a00023]           FLOAT (53)     NULL,
    [a00024]           FLOAT (53)     NULL,
    [a00025]           FLOAT (53)     NULL,
    CONSTRAINT [pkbvd] PRIMARY KEY CLUSTERED ([companyPrimKey] ASC)
);





