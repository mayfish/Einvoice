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
		<script type="text/javascript">
			var q_name = "vccar_s";
			function z_vccar() {
			}
            z_vccar.prototype = {
                acomp : ''
            };
            var t_data = new z_vccar();
            
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

				bbmMask = [['txtMon', r_picm]];
				q_mask(bbmMask);
				q_gt('acomp', '', 0, 0, 0, "");
				$('#txtMon').focus();
			}
			function q_gtPost(t_name) {
                switch (t_name) {
                    case 'acomp':
                        t_data.acomp = '@全部';
                        var as = _q_appendData("acomp", "", true);
                        for ( i = 0; i < as.length; i++) {
                            t_data.acomp += (t_data.acomp.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].acomp;
                        }
                        break;
                }
                if (t_data.acomp.length > 0){
                    q_cmbParse("cmbCno", t_data.acomp);
                }
            }

			function q_seekStr() {
				t_mon = $('#txtMon').val();
				t_invono = $.trim($('#txtInvono').val());
				t_cno = $('#cmbCno').val();

				var t_where = " 1=1 ";
				if (t_mon.replace(/\//g,'').replace(/ /g,'') > 0)
                    t_where += " and ( '"+t_mon+"' between left(bdate,6) and left(edate,6) )";
                if (t_invono.length > 0)
                    t_where += " and ( '"+t_invono+"' between left(binvono,"+t_invono.length+") and left(einvono,"+t_invono.length+") )";
				if (t_cno.length > 0)
                    t_where += q_sqlPara2("cno", t_cno);
				t_where = ' where=^^ ' + t_where + ' ^^ ';
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
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<div style='width:400px; text-align:center;padding:15px;' >
			<table id="seek"  border="1"   cellpadding='3' cellspacing='2' style='width:100%;' >
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblAcomp'> </a></td>
					<td><select id="cmbCno" style="width:215px; font-size:medium;" > </select></td>
				</tr>
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblMon'> </a></td>
					<td>
					<input class="txt" id="txtMon" type="text" style="width:120px; font-size:medium;" />
					</td>
				</tr>
				
				<tr class='seek_tr'>
					<td class='seek'  style="width:20%;"><a id='lblInvono'> </a></td>
					<td>
					<input class="txt" id="txtInvono" type="text" style="width:120px; font-size:medium;" />
					</td>
				</tr>
			</table>
			<!--#include file="../inc/seek_ctrl.inc"-->
		</div>
	</body>
</html>