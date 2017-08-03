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

            q_tables = 's';
            var q_name = "vccb";
            var q_readonly = ['txtNoa','txtAccno','txtWorker','txtMoney','txtTax','txtTotal','txtVccno'];
            var q_readonlys = [];
            var bbmNum = [['txtMoney', 10, 0, 1], ['txtTotal', 10, 0, 1], ['txtTax', 10, 0, 1]];
            var bbsNum = [['txtMount', 10, 3, 1], ['txtPrice', 10, 3, 1], ['txtTotal', 10, 0, 1], ['txtTax', 10, 0, 1]];
            var bbmMask = [];
            var bbsMask = [];
            q_sqlCount = 6;
            brwCount = 6;
            brwCount2 = 6;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'Datea';
            q_desc = 1;
            aPop = new Array(
             ['txtCustno', 'lblCust', 'cust', 'noa,comp,nick,serial,addr_invo', 'txtCustno,txtComp,txtNick,txtSerial,txtAddr', 'cust_b.aspx']
            , ['txtInvono_', '', 'vcca', 'noa,datea,serial,custno,comp,cno,acomp,productno,product,price,mount,money,tax,taxtype', '0txtInvono_,txtIdate_,txtSerial_,txtCustno_,txtComp_,txtCno_,txtAcomp_,txtProductno_,txtProduct_,txtPrice_,txtMount_,txtTotal_,txtTax_,cmbTaxtype_', 'vcca_b.aspx']
       		, ['txtTggno', 'lblTgg', 'tgg', 'noa,comp,serial,addr_invo', 'txtTggno,txtTgg,txtSerial,txtAddr', 'tgg_b.aspx']
            , ['txtProductno_', 'btnProductno_', 'ucca', 'noa,product', 'txtProductno_,txtProduct_', 'ucca_b.aspx']);
			
			var t_acomp = '';
            $(document).ready(function() {
                bbmKey = ['noa'];
                bbsKey = ['noa', 'noq'];
                q_brwCount();
                q_gt('acomp', '', 0, 0, 0, "");
                
            });

            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }

                mainForm(1);
            }

            function mainPost() {
                q_getFormat();
                bbmMask = [['txtMon', r_picm],['txtDatea', r_picd],['txtVkdate', r_picd],['txtWdate', r_picd],['txtWtime', '99:99:99']];
                q_mask(bbmMask);
                bbsMask = [['txtIdate', r_picd]];
                q_mask(bbsMask);
                q_cmbParse("cmbCno", t_acomp);
                q_cmbParse("cmbTypea", q_getPara('vccb.typea'));
                q_cmbParse("cmbTaxtype", q_getPara('sys.taxtype'),'s');
                
                typea_chg();
                
                $('#chkCancel').click(function(e){
                	typea_chg();
                });
	            $('#lblAccno').click(function () {
			        q_pop('txtAccno', "accc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";accc3='" + $('#txtAccno').val() + "';" + $('#txtDatea').val().substring(0,3) + '_1', 'accc', 'accc3', 'accc2', "92%", "1054px", q_getMsg('popAccc'), true);
			    });
			    
               	$('#lblVccno').click(function() {
               		if(!emp($('#txtVccno').val())){
	               		if($('#cmbTypea').val() == 1 || $('#cmbTypea').val() == 2){
							q_pop('txtVccno', "umma.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $('#txtVccno').val() + "';" + $('#txtDatea').val().substring(0,3), 'umma', 'noa', 'datea', "95%", "95%", q_getMsg('popUmma'), true);
						}else if($('#cmbTypea').val() == 3 || $('#cmbTypea').val() == 4){
							q_pop('txtVccno', "paya.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $('#txtVccno').val() + "';" + $('#txtDatea').val().substring(0,3), 'paya', 'noa', 'datea', "95%", "95%", q_getMsg('popPaya'), true);
						}
					}
                });
                
                $('#cmbTypea').change(function() {
                    if(q_getPara('sys.project').toUpperCase()=='IT') {
	                	if($('#cmbTypea').val()=='1' || $('#cmbTypea').val()=='3'){
		                	for (var j = 0; j < q_bbsCount; j++) {
		                		$('#txtTotal_'+j).attr('disabled', 'disabled');
		                	}
	                	}else{
	                		for (var j = 0; j < q_bbsCount; j++) {
	                			$('#txtTotal_'+j).removeAttr('disabled');
	                		}
	                	}
	                }
                });
                
                $('#txtDatea').change(function() {
                    $('#txtMon').val($('#txtDatea').val().substr(0,r_picm));
                });
                
                $('#btnB0101').click(function(e){
					var t_noa = $.trim($('#txtNoa').val());
					if(t_noa.length==0){
						
					}else{
						q_box("generateB0101.aspx?db="+q_db+"&bno="+t_noa+"&eno="+t_noa, "generateB0101", "95%", "95%", '');
					}
				});
				$('#btnB0201').click(function(e){
					var t_noa = $.trim($('#txtNoa').val());
					if(t_noa.length==0){
						
					}else{
						q_box("generateB0201.aspx?db="+q_db+"&bno="+t_noa+"&eno="+t_noa, "generateB0201", "95%", "95%", '');
					}
				});
				$('#btnA0301').click(function(e){
					var t_noa = $.trim($('#txtNoa').val());
					if(t_noa.length==0){
						
					}else{
						q_box("generateA0301.aspx?db="+q_db+"&bno="+t_noa+"&eno="+t_noa, "generateA0301", "95%", "95%", '');
					}
				});
				$('#btnA0601').click(function(e){
					var t_noa = $.trim($('#txtNoa').val());
					if(t_noa.length==0){
						
					}else{
						q_box("generateA0601.aspx?db="+q_db+"&bno="+t_noa+"&eno="+t_noa, "generateA0601", "95%", "95%", '');
					}
				});
				$('#btnB0401').click(function(e){
					var t_noa = $.trim($('#txtNoa').val());
					if(t_noa.length==0){
						
					}else{
						q_box("generateB0401.aspx?db="+q_db+"&bno="+t_noa+"&eno="+t_noa, "generateB0401", "95%", "95%", '');
					}
				});
                $('#btnB0501').click(function(e){
					var t_noa = $.trim($('#txtNoa').val());
					if(t_noa.length==0){
						
					}else{
						q_box("generateB0501.aspx?db="+q_db+"&bno="+t_noa+"&eno="+t_noa, "generateB0501", "95%", "95%", '');
					}
				});
            }
            function q_boxClose(s2) {///   q_boxClose 2/4
                var ret;
                switch (b_pop) {
                    case q_name + '_s':
                        q_boxClose2(s2);
                        ///   q_boxClose 3/4
                        break;
                }/// end Switch
                b_pop = '';
            }
			
            function q_gtPost(t_name) {
                switch (t_name) {
                	case 'acomp':
                        var as = _q_appendData("acomp", "", true);
                        if (as[0] != undefined) {
                            t_acomp = " @ ";
                            for ( i = 0; i < as.length; i++) {
                                t_acomp += (t_acomp.length > 0 ? ',' : '') + as[i].noa + '@' + as[i].acomp;
                            }
                        }
                        q_gt(q_name, q_content, q_sqlCount, 1);
                        break;
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                        break;
                }  /// end switch
            }
            function q_stPost() {
                if (!(q_cur == 1 || q_cur == 2))
                    return false;
                	abbm[q_recno]['accno'] = xmlString.split(';')[0];
                	abbm[q_recno]['vccno'] = xmlString.split(';')[1];
            }
			function q_popPost(id) {
				switch(id) {
					case 'txtInvono_':
						var n = b_seq;	
						$('#cmbCno').val($('#txtCno_'+n).val());
						$('#txtCustno').val($('#txtCustno_'+n).val());
						$('#txtComp').val($('#txtComp_'+n).val());
						$('#txtSerial').val($('#txtSerial_'+n).val());
						break;
				}
			}
            function btnOk() {
            	var t_err = '';
            	t_err = q_chkEmpField([['txtDatea', q_getMsg('lblDatea')], ['cmbCno', q_getMsg('lblCno')]]);
				if (t_err.length > 0) {
					alert(t_err);
					return;
				}
            	
                if($('#txtDatea').val().length==0 || !q_cd($('#txtDatea').val())){
                	alert(q_getMsg('lblDatea')+'錯誤。');
                	return;
                }
                
                if(emp($('#txtMon').val()))
                	$('#txtMon').val($('#txtDatea').val().substr(0,r_picm));

                $('#txtWorker').val(r_name);
                sum();
                var t_noa = trim($('#txtNoa').val());
				var t_date = trim($('#txtDatea').val());
                if (t_noa.length == 0 || t_noa == "AUTO")
                    q_gtnoa(q_name, replaceAll(q_getPara('sys.key_vccb') + (t_date.length == 0 ? q_date() : t_date), '/', ''));
                else
                    wrServer(t_noa);
            }

            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)// 1-3
                    return;
                q_box('vccb_s.aspx', q_name + '_s', "500px", "450px", q_getMsg("popSeek"));
            }

            function bbsAssign() {
            	for (var j = 0; j < q_bbsCount; j++) {
                	$('#lblNo_'+j).text(j+1);	
                	if ($('#btnMinus_' + j).hasClass('isAssign'))
                		continue;
                		
            		$('#txtMount_' + j).change(function(e){
            			var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
						var t_mount = q_float('txtMount_'+n);
						var t_price = q_float('txtPrice_'+n);
						var t_money = round(t_mount * t_price,0);
						$('#txtTotal_'+n).val(t_money);
            			sum();
            		});
            		$('#txtPrice_' + j).change(function(e){
            			var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
            			var t_mount = q_float('txtMount_'+n);
						var t_price = q_float('txtPrice_'+n);
						var t_money = round(t_mount * t_price,0);
						$('#txtTotal_'+n).val(t_money);
            			sum();
            		});
            		$('#txtTotal_' + j).change(function(e){
            			sum();
            		});
            		$('#txtTax_' + j).change(function(e){
            			sum();
            		});
            	}
                _bbsAssign();
            }

            function btnIns() {
                _btnIns();
                $('#txtNoa').val('AUTO');
                $('#txtDatea').val(q_date());
                $('#txtMon').val(q_date().substr(0,r_picm));
                $('#txtDatea').focus();
                $('#cmbCno')[0].selectedIndex=1;//第一個是空白,所以跳第2個
                typea_chg();
                if(q_getPara('sys.project').toUpperCase()=='IT') {
                	if($('#cmbTypea').val()=='1' || $('#cmbTypea').val()=='3'){
	                	for (var j = 0; j < q_bbsCount; j++) {
	                		$('#txtTotal_'+j).attr('disabled', 'disabled');
	                	}
                	}
                }
            }

            function btnModi() {
                if (emp($('#txtNoa').val()))
                    return;
                _btnModi();
                $('#txtDatea').focus();
                if(q_getPara('sys.project').toUpperCase()=='IT') {
                	if($('#cmbTypea').val()=='1' || $('#cmbTypea').val()=='3'){
	                	for (var j = 0; j < q_bbsCount; j++) {
	                		$('#txtTotal_'+j).attr('disabled', 'disabled');
	                	}
                	}
                }
            }

            function btnPrint() {
            	if (q_getPara('sys.project') == 'pk') {
					q_box('z_vccb_pk.aspx' + "?;;;noa=" + trim($('#txtNoa').val())+";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
				}else{
					q_box('z_vccb.aspx' + "?;;;noa=" + trim($('#txtNoa').val())+";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
				}
            }
			function typea_chg(){
				
				if($('#cmbTypea').val() == 1 || $('#cmbTypea').val() == 2){
					$('#Cust').show();
					$('#Tgg').hide();
					$('#txtTggno').val('');
					$('#txtTgg').val('');
					$('#lblVccno').text('預收單號');
					aPop = new Array(
			             ['txtCustno', 'lblCust', 'cust', 'noa,comp,nick,serial,addr_invo', 'txtCustno,txtComp,txtNick,txtSerial,txtAddr', 'cust_b.aspx']
			            , ['txtInvono_', '', 'vcca', 'noa,datea,serial,custno,comp,cno,acomp,productno,product,price,mount,money,tax,taxtype', '0txtInvono_,txtIdate_,txtSerial_,txtCustno_,txtComp_,txtCno_,txtAcomp_,txtProductno_,txtProduct_,txtPrice_,txtMount_,txtTotal_,txtTax_,cmbTaxtype_', 'vcca_b.aspx']
			       		, ['txtTggno', 'lblTgg', 'tgg', 'noa,comp,serial,addr_invo', 'txtTggno,txtTgg,txtSerial,txtAddr', 'tgg_b.aspx']
			            , ['txtProductno_', 'btnProductno_', 'ucca', 'noa,product', 'txtProductno_,txtProduct_', 'ucca_b.aspx']);
            
				}else if($('#cmbTypea').val() == 3 || $('#cmbTypea').val() == 4){
					$('#Cust').hide();
					$('#txtCustno').val('');
					$('#txtComp').val('');
					$('#Tgg').show();
					$('#lblVccno').text('預付單號');
					aPop = new Array(
			             ['txtCustno', 'lblCust', 'cust', 'noa,comp,nick,serial,addr_invo', 'txtCustno,txtComp,txtNick,txtSerial,txtAddr', 'cust_b.aspx']
						, ['txtSerial', 'lblSerial', 'vccabuyer', 'serial,buyer', '0txtSerial,txtComp', 'vccabuyer_b.aspx']
			            , ['txtInvono_', '', 'rc2a', 'noa,datea,serial,tggno,comp,cno,acomp,money,tax,taxtype', '0txtInvono_,txtIdate_,txtSerial_,txtCustno_,txtComp_,txtCno_,txtAcomp_,txtTotal_,txtTax_,cmbTaxtype_', 'vcca_b.aspx']
			       		, ['txtTggno', 'lblTgg', 'tgg', 'noa,comp,serial,addr_invo', 'txtTggno,txtTgg,txtSerial,txtAddr', 'tgg_b.aspx']
			            , ['txtProductno_', 'btnProductno_', 'ucca', 'noa,product', 'txtProductno_,txtProduct_', 'ucca_b.aspx']);
				}
			}
            function wrServer(key_value) {
                var i;

                $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
                _btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
            }

            function bbsSave(as) {
                if (!as['invono']) {
                    as[bbsKey[1]] = '';
                    return;
                }

                q_nowf();
                as['cno'] = abbm2['cno'];
                as['datea'] = abbm2['datea'];
                return true;
            }

            function sum() {
                var t_mount,t_price,t_money,t_tax;
                var tot_money=0,tot_tax=0;
                for (var j = 0; j < q_bbsCount; j++) {
					t_money = q_float('txtTotal_'+j);
					t_tax = q_float('txtTax_'+j);
					tot_money += t_money;
					tot_tax += t_tax;
                } 
				$('#txtMoney').val(tot_money);
				$('#txtTax').val(tot_tax);
				$('#txtTotal').val(tot_money+tot_tax);
            }

            function refresh(recno) {
                _refresh(recno);
               
                typea_chg();
            }

            function readonly(t_para, empty) {
                _readonly(t_para, empty);
            }

            function btnMinus(id) {
                _btnMinus(id);
                sum();
            }

            function btnPlus(org_htm, dest_tag, afield) {
                _btnPlus(org_htm, dest_tag, afield);
                if(q_getPara('sys.project').toUpperCase()=='IT') {
                	if($('#cmbTypea').val()=='1' || $('#cmbTypea').val()=='3'){
	                	for (var j = 0; j < q_bbsCount; j++) {
	                		$('#txtTotal_'+j).attr('disabled', 'disabled');
	                	}
                	}
                }
            }

            function q_appendData(t_Table) {
                return _q_appendData(t_Table);
            }

            function btnSeek() {
                _btnSeek();
            }

            function btnTop() {
                _btnTop();
            }

            function btnPrev() {
                _btnPrev();
            }

            function btnPrevPage() {
                _btnPrevPage();
            }

            function btnNext() {
                _btnNext();
            }

            function btnNextPage() {
                _btnNextPage();
            }

            function btnBott() {
                _btnBott();
            }

            function q_brwAssign(s1) {
                _q_brwAssign(s1);
            }

            function btnDele() {
                _btnDele();
            }

            function btnCancel() {
                _btnCancel();
            }
		</script>
		<style type="text/css">
            #dmain {
                overflow: hidden;
            }
            .dview {
                float: left;
                width: 250px;
                border-width: 0px;
            }
            .tview {
                border: 5px solid gray;
                font-size: medium;
                background-color: black;
                width: 100%;
            }
            .tview tr {
                height: 30px;
            }
            .tview td {
                padding: 2px;
                text-align: center;
                border-width: 0px;
                background-color: #FFFF66;
                color: blue;
            }
            .dbbm {
                float: left;
                width: 700px;
                /*margin: -1px;
                 border: 1px black solid;*/
                border-radius: 5px;
            }
            .tbbm {
                padding: 0px;
                border: 1px white double;
                border-spacing: 0;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: #cad3ff;
                width: 100%;
            }
            .tbbm tr {
                height: 35px;
            }
            .tbbm tr td {
                width: 10%;
            }
            .tbbm .tdZ {
                width: 1%;
            }
            td .schema {
                display: block;
                width: 95%;
                height: 0px;
            }
            .tbbm tr td span {
                float: right;
                display: block;
                width: 5px;
                height: 10px;
            }
            .tbbm tr td .lbl {
                float: right;
                color: blue;
                font-size: medium;
            }
            .tbbm tr td .lbl.btn {
                color: #4297D7;
                font-weight: bolder;
            }
            .tbbm tr td .lbl.btn:hover {
                color: #FF8F19;
            }
            .txt.c1 {
                width: 100%;
                float: left;
            }
            .txt.num {
                text-align: right;
            }
            .tbbm td {
                margin: 0 -1px;
                padding: 0;
            }
            .tbbm td input[type="text"] {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                float: left;
            }
            .tbbm select {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                font-size: medium;
            }
            .dbbs {
                width: 100%;
            }
            .tbbs a {
                font-size: medium;
            }
            .tbbs input[type="text"] {
                width: 95%;
            }
            .num {
                text-align: right;
            }
            input[type="text"], input[type="button"], select {
                font-size: medium;
            }
		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' >
			<div class="dview" id="dview">
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewDatea'> </a></td>
						<td align="center" style="width:100px; color:black;"><a id='vewComp'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" /></td>
						<td id="datea" style="text-align: center;">~datea</td>
						<td id="comp,4 tgg,4" style="text-align: center;">~comp,4 ~tgg,4</td>
					</tr>
				</table>
			</div>
			<div class='dbbm'>
				<table class="tbbm"  id="tbbm">
					<tr style="height:1px;">
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td class="tdZ"> </td>
					</tr>
					<tr>
						<td><span> </span><a id='lblDatea' class="lbl"> </a></td>
						<td><input id="txtDatea"  type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblMon' class="lbl"> </a></td>
						<td><input id="txtMon"  type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td><input id="txtNoa"  type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblTypea' class="lbl"> </a></td>
						<td><select id="cmbTypea" class="txt c1" onchange="typea_chg();"> </select></td>
						<td><span> </span><a id='lblCno' class="lbl"> </a></td>
						<td>
							<select id="cmbCno" class="txt c1"> </select>
							<input id="txtAcomp" type="text" style="display:none;"/>
						</td>
						<td><span> </span><a id='lblSerial' class="lbl"> </a></td>
						<td><input id="txtSerial"  type="text" class="txt c1"/></td>
					</tr>
					<tr id='Cust'>
						<td><span> </span><a id='lblCust' class="lbl btn"> </a></td>
						<td colspan="3">
							<input id="txtCustno" type="text" style="float:left; width:30%;"/>
							<input id="txtComp" type="text" style="float:left; width:70%;"/>
							<input id="txtNick" type="text" style="display:none;"/>
						</td>
						<td><span> </span><a id='lblVkdate' class="lbl"> </a></td>
						<td><input id="txtVkdate" type="text" class="txt c1"/></td>
					</tr>
					<tr id='Tgg'>
						<td><span> </span><a id='lblTgg' class="lbl btn"> </a></td>
						<td colspan="3">
							<input id="txtTggno" type="text" style="float:left; width:30%;"/>
							<input id="txtTgg" type="text" style="float:left; width:70%;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAddr' class="lbl"> </a></td>
						<td colspan="3"><input id="txtAddr"  type="text" class="txt c1"/></td>
						<td><span> </span><a class="lbl">作廢</a></td>
						<td><input id="chkCancel"  type="checkbox"/></td>
					</tr>
					<tr class="Cancel">
						<td><span> </span><a id='lblWdate' class="lbl">退回/作廢日期</a></td>
						<td><input id="txtWdate"  type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblWtime' class="lbl">退回/作廢時間</a></td>
						<td><input id="txtWtime"  type="text" class="txt c1" /></td>
						<td><span> </span><a id='lblWmemo' class="lbl">退回/作廢原因</a></td>
						<td><input id="txtWmemo"  type="text" class="txt c1"  maxlength=20/></td>
						<!--只能20個字元-->
					</tr>
					<tr>
						<td><span> </span><a id='lblMoney' class="lbl"> </a></td>
						<td><input id="txtMoney"  type="text" class="txt num c1"/></td>
						<td><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td><input id="txtTax"  type="text" class="txt num c1" /></td>
						<td><span> </span><a id='lblTotal' class="lbl"> </a></td>
						<td><input id="txtTotal"  type="text" class="txt num c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAccno' class="lbl btn"> </a></td>
						<td><input id="txtAccno" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblVccno' class="lbl btn"> </a></td>
						<td><input id="txtVccno" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td><input id="txtWorker"  type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo"  class="lbl"> </a></td>
						<td colspan="5"><input id="txtMemo"  type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td> </td>
						<td><input type="checkbox" style="float:left;" id="chkIssend"/><span style="display:block;width:100px;float:left;">開立</span></td>
						<td><input type="checkbox" style="float:left;" id="chkIsconfirm"/><span style="display:block;width:100px;float:left;">確認</span></td>
					</tr>
				</table>
			</div>
			
			<input type="button" class="einvoice" id="btnA0301" value="[A0301]退回(買方)發票" style="float:left;width:200px;height:50px;white-space:normal;display:none;"/>
			<input type="button" class="einvoice" id="btnA0601" value="[A0601]退回(買方)發票存證" style="float:left;width:200px;height:50px;white-space:normal;display:none;"/>
			<input type="button" class="einvoice" id="btnB0101" value="[B0101]開立(買方)/傳送(賣方)折讓證明" style="float:left;width:200px;height:50px;white-space:normal;display:none;"/>
			<input type="button" class="einvoice" id="btnB0201" value="[B0201]作廢(買方)折讓證明單" style="float:left;width:200px;height:50px;white-space:normal;display:none;"/>
			<input type="button" class="einvoice" id="btnB0401" value="[B0401]開立(買方)/傳送(賣方)折讓證明單存證" style="float:left;width:200px;height:50px;white-space:normal;display:none;"/>
			<input type="button" class="einvoice" id="btnB0501" value="[B0501]作廢折讓證明單存證" style="float:left;width:200px;height:50px;white-space:normal;display:none;"/>
		</div>
		
		<div class='dbbs' >
			<table id="tbbs" class='tbbs'  border="1"  cellpadding='2' cellspacing='1'  >
				<tr style='color:white; background:#003366;' >
					<td  align="center" style="width:30px;">
					<input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  />
					</td>
					<td align="center" style="width:20px;"> </td>
					<td align="center" style="width:15px;"><a id='lblCobtype'>聯式</a></td>
					<td align="center" style="width:100px;"><a id='lblInvono'> </a></td>
					<td align="center" style="width:60px;"><a id='lblIdate'> </a></td>
					<td align="center" style="width:80px;"><a id='lblProductno'> </a></td>
					<td align="center" style="width:150px;"><a id='lblProduct'> </a></td>
					<td align="center" style="width:20px;"><a id='lblMount'> </a></td>
					<td align="center" style="width:60px;"><a id='lblPrice'> </a></td>
					<td align="center" style="width:60px;"><a id='lblTotals'> </a></td>
					<td align="center" style="width:60px;"><a id='lblTaxs'> </a></td>
					<td align="center" style="width:60px;"><a id='lblTaxtypes'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td>
						<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
						<input id="txtNoq.*"  style="display:none;"/>
					</td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td><input  id="txtCobtype.*" type="text" class="txt c1"/></td>
					<td>
						<input  id="txtInvono.*" type="text" class="txt c1"/>
						<input  id="txtSerial.*" type="text" style="display:none;"/>
						<input  id="txtCustno.*" type="text" style="display:none;"/>
						<input  id="txtComp.*" type="text" style="display:none;"/>
						<input  id="txtCno.*" type="text" style="display:none;"/>
						<input  id="txtAcomp.*" type="text" style="display:none;"/>
					</td>
					<td><input  id="txtIdate.*" type="text" class="txt c1"/></td>
					<td>
						<input id="btnProductno.*" type="button" value="." style="width: auto; font-size: medium;" />
						<input  id="txtProductno.*" type="text" style="width: 70%;"/>
					</td>
					<td><input  id="txtProduct.*" type="text" class="txt c1"/></td>
					<td><input  id="txtMount.*" type="text" class="txt num c1" /></td>
					<td><input  id="txtPrice.*" type="text" class="txt num c1" /></td>
					<td><input  id="txtTotal.*" type="text" class="txt num c1" /></td>
					<td><input  id="txtTax.*" type="text" class="txt num c1"/></td>
					<td><select  id="cmbTaxtype.*" type="text" class="txt c1"> </select></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>
