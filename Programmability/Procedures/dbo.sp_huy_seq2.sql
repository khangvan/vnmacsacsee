SET QUOTED_IDENTIFIER, ANSI_NULLS ON
GO

CREATE  PROCEDURE [dbo].[sp_huy_seq2]
	@dt smalldatetime = NULL
AS
	set nocount on

	exec sp_huy_seq1 'BBIRDFOCUS1',@dt
	exec sp_huy_seq1 'G2DFOCUS1',@dt
	exec sp_huy_seq1 'G2DFOCUS2',@dt
	exec sp_huy_seq1 'G2DFOCUS3',@dt
	exec sp_huy_seq1 'G2DFOCUS4',@dt
	exec sp_huy_seq1 'G2DFOCUS5',@dt
	exec sp_huy_seq1 'HALOFOCUS2',@dt
	exec sp_huy_seq1 'HALOFOCUS4',@dt
	exec sp_huy_seq1 'HNFOCUS5',@dt
	exec sp_huy_seq1 'LTFOCUS4',@dt
	exec sp_huy_seq1 'LTFOCUS5',@dt
	exec sp_huy_seq1 'MGL94FOCUS1',@dt
	exec sp_huy_seq1 'MGL94FOCUS2',@dt
	exec sp_huy_seq1 'MGL98FOCUS1',@dt
	exec sp_huy_seq1 'MGL98FOCUS2',@dt
	exec sp_huy_seq1 'MGL98FOCUS3',@dt
	exec sp_huy_seq1 'MGL98FOCUS4',@dt
	exec sp_huy_seq1 'MGL98TDRFOCUS1',@dt
	exec sp_huy_seq1 'MGL98TDRFOCUS2',@dt
	exec sp_huy_seq1 'MPFOCUS1',@dt
	exec sp_huy_seq1 'MPFOCUS2',@dt
	exec sp_huy_seq1 'MPFOCUS3',@dt
	exec sp_huy_seq1 'MPFOCUS4',@dt
	exec sp_huy_seq1 'MPFOCUS5',@dt
	exec sp_huy_seq1 'VNCOBFOCUS1',@dt



GO