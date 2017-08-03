<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
		<script src="../script/qbox.js" type="text/javascript"></script>
		<link href="../qbox.css" rel="stylesheet" type="text/css" />
		<link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
            var q_name = "vccb_s";
            var aPop = new Array(['txtTggno', '', 'tgg', 'noa,comp', 'txtTggno', 'tgg_b.aspx']
            	, ['txtCustno', 'lblCust', 'cust', 'noa,comp', 'txtCustno', 'cust_b.aspx']);
            $(document).ready(function() {
                main();
            });
            /// end ready

            function main() {
                mainSeek();
                q_gf('', q_name);
            }

            function q_gfPost() {
                q_getFormat();
                q_langShow();

                bbmMask = [['txtBdate', r_picd], ['txtEdate', r_picd]];
                q_mask(bbmMask);
                q_cmbParse("cmbTypea", " @全部,"+q_getPara('vccb.typea'));
                $('#txtNoa').focus();
				$('#txtBdate').datepicker();
				$('#txtEdate').datepicker();
            }

            function q_seekStr() {
            	t_bdate = $('#txtBdate').val();
                t_edate = $('#txtEdate').val();
                t_noa = $('#txtNoa').val();
                t_tggno = $('#txtTggno').val();
                t_tgg = $('#txtTgg').val();
                t_custno = $('#txtCustno').val();
                t_cust = $('#txtCust').val();
             	t_invoice = $('#txtInvoice').val();
             	t_typea = $('#cmbTypea').val();
             	
                var t_where = " 1=1 " 
                	+ q_sqlPara2("noa", t_noa) 
                	+ q_sqlPara2("tggno", t_tggno) 
                	+ q_sqlPara2("custno", t_custno) 
                	+ q_sqlPara2("datea", t_bdate, t_edate);
				if(t_typea.length>0)
					t_where += " and typea='"+t_typea+"'";
				if(t_tgg.length>0)
					t_where += " and charindex(N'"+t_tgg+"',tgg)>0";
				if(t_cust.length>0)
					t_where += " and charindex(N'"+t_cust+"',comp)>0";
				if (t_invoice.length>0)
                	t_where += " and exists(select noa from vccbs where vccbs.noa=vccb.noa and charindex('" + t_invoice + "',vccbs.invono)>0)";
                		
                t_where = ' where=^^' + t_where + '^^ ';
                return t_where;
            }
		</script>
		<style type="text/css">
            .seek_tr {
                color: white;
                text-align: center;
                font-weight: bold;
                BACKGROUND-COLOR: #76a2fe
            }
		</style>
	</head>
	<body>
		<div style='width:400px; text-align:center;padding:15px;' >
			<table id="seek"  border="1"   cellpadding='3' cellspacing='2' style='width:100%;' >
				<tr class='seek_tr'>
					<td style="width:35%;" ><a>類別</a></td>
					<td style="width:65%;  ">
						<select id="cmbTypea" style="width:215px; font-size:medium;"> </select>
					</td>
				</tr>
				<tr class='seek_tr'>
					<td   style="width:35%;" ><a id='lblDatea'> </a></td>
					<td style="width:65%;  ">
					<input class="txt" id="txtBdate" type="text" style="width:90px; font-size:medium;" />
					<span style="display:inline-block; vertical-align:middle">&sim;</span>
					<input class="txt" id="txtEdate" type="text" style="width:93px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblNoa'> </a></td>
					<td>
					<input class="txt" id="txtNoa" type="text" style="width:215px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a>廠商編號</a></td>
					<td><input class="txt" id="txtTggno" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a>廠商名稱</a></td>
					<td><input class="txt" id="txtTgg" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a>客戶編號</a></td>
					<td><input class="txt" id="txtCustno" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a>客戶名稱</a></td>
					<td><input class="txt" id="txtCust" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a>發票號碼</a></td>
					<td><input class="txt" id="txtInvoice" type="text" style="width:215px; font-size:medium;" /></td>
				</tr>
			</table>
			<!--#include file="../inc/seek_ctrl.inc"-->
		</div>
	</body>
</html>
