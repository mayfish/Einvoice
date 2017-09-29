<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title></title>
		<script src="../script/jquery.min.js" type="text/javascript"></script>
		<script src='../script/qj2.js' type="text/javascript"></script>
		<script src='qset.js' type="text/javascript"></script>
		<script src='../script/qj_mess.js' type="text/javascript"></script>
		<script src='../script/mask.js' type="text/javascript"></script>
        <link href="../qbox.css" rel="stylesheet" type="text/css" />
        <link href="css/jquery/themes/redmond/jquery.ui.all.css" rel="stylesheet" type="text/css" />
		<script src="css/jquery/ui/jquery.ui.core.js"></script>
		<script src="css/jquery/ui/jquery.ui.widget.js"></script>
		<script src="css/jquery/ui/jquery.ui.datepicker_tw.js"></script>
		<script type="text/javascript">
			var q_name = "vcca_s";
			aPop = new Array(['txtCustno', 'lblCust', 'cust', 'noa,comp', 'txtCustno', 'cust_b.aspx']
			,['txtSerial', 'lblSerial', 'vccabuyer', 'serial,buyer', 'txtSerial', 'vccabuyer_b.aspx']);
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

				bbmMask = [['txtBdate', r_picd], ['txtEdate', r_picd], ['txtMon', r_picm]];
				
				q_mask(bbmMask);
				q_gt('acomp', '', 0, 0, 0, "");
				$('#txtBdate').focus();
				if(r_len==3){
					$('#txtBdate').datepicker();
					$('#txtEdate').datepicker();
				}
			}
			function q_gtPost(t_name) {
                switch (t_name) {
                    case 'acomp':
                        var t_acomp = '@全部';
                        var as = _q_appendData("acomp", "", true);
                        for (var i =0;i<as.length;i++) {
                            t_acomp += (t_acomp.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].acomp;
                        }
                        q_cmbParse("cmbAcomp", t_acomp);
                        break;
                }
            }
			function q_seekStr() {
				t_cno = $('#cmbAcomp').val();
				t_noa = $('#txtNoa').val();
				t_bdate = $('#txtBdate').val();
				t_edate = $('#txtEdate').val();
				t_mon = $('#txtMon').val();
				
				t_key = $('#txtKey').val();
				
				var t_where = " 1=1 " 
					+ q_sqlPara2("cno", t_cno)
					+ q_sqlPara2("mon", t_mon)
					+ q_sqlPara2("noa", t_noa)
					+ q_sqlPara2("datea", t_bdate, t_edate);

				if(t_key.length>0){
					t_where +=" and (";
					t_where += "charindex('" + t_key + "',custno)>0";
					t_where += " or charindex('" + t_key + "',comp)>0";
					t_where += " or charindex('" + t_key + "',nick)>0";
					t_where += " or charindex('" + t_key + "',serial)>0";
					t_where += " or charindex('" + t_key + "',buyerno)>0";
					t_where += " or charindex('" + t_key + "',buyer)>0";
					t_where +=")";
				}
				t_where = ' where=^^' + t_where + '^^ ';
				return t_where;
			}
		</script>
		<style type="text/css">
			.seek_tr {
				color: white;
				text-align: center;
				font-weight: bold;
				background-color: #76a2fe
			}
		</style>
	</head>
	<body>
		<div style='width:400px; text-align:center;padding:15px;' >
			<table id="seek"  border="1"   cellpadding='3' cellspacing='2' style='width:100%;' >
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblAcomp'> </a></td>
					<td><select id="cmbAcomp" style="width:215px; font-size:medium;" > </select></td>
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
					<td class='seek'  style="width:20%;"><a id='lblMon'></a></td>
					<td>
					<input class="txt" id="txtMon" type="text" style="width:215px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblNoa'></a></td>
					<td>
					<input class="txt" id="txtNoa" type="text" style="width:215px; font-size:medium;" />
					</td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblKey'>編號、名稱、統編</a></td>
					<td>
					<input class="txt" id="txtKey" type="text" style="width:215px; font-size:medium;" />
					</td>
				</tr>
				
			</table>
			<!--#include file="../inc/seek_ctrl.inc"-->
		</div>
	</body>
</html>
