<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr">
	<head>
		<title> </title>
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
			//2017/02/18  rev 由 invoicetype取代,由於相容性rev仍會寫入值
            q_tables = 's';
            var q_name = "vccar";
            var q_readonly = ['txtNoa'];
            var q_readonlys = ['txtNo2','txtBinvono','txtEinvono'];
            var bbmNum = [];
            var bbsNum = [];
            var bbmMask = [];
            var bbsMask = [];
            q_desc = 1;
            q_sqlCount = 6;
            brwCount = 6;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'noa';
            //ajaxPath = ""; //  execute in Root
            aPop = new Array(['txtCno', 'lblCno', 'acomp', 'noa,acomp,nick', 'txtCno,txtAcomp,txtNick', 'acomp_b.aspx']
            , ['txtCustno_', 'btnCust_', 'cust', 'noa,comp', 'txtCustno_,txtComp_', 'cust_b.aspx']);
            
            var t_invoicetype = '';
            $(document).ready(function() {
                bbmKey = ['noa'];
                bbsKey = ['noa', 'noq'];
                q_brwCount();
                
                q_gt('invoicetype', '', 0, 0, 0, "getInvoicetype", r_accy);
                
            });
			
            function main() {
                if (dataErr) {
                    dataErr = false;
                    return;
                }
                mainForm(1);
                // 1=Last  0=Top
            }///  end Main()

            function mainPost() {

                bbmMask = [['txtBdate', r_picd], ['txtEdate', r_picd]];
                q_mask(bbmMask);
                bbsMask = [['txtDatea', r_picd]];
				
				q_cmbParse("cmbInvoicetype", t_invoicetype);
				
				if(r_len==3){
					$('#txtBdate').datepicker();
					$('#txtEdate').datepicker();
				}
				
                $('#txtBinvono').focus(function(e){
                	$(this).css("color","black");
                }).blur(function(e) {
                	$(this).val($.trim($(this).val().toUpperCase()));
                	if(!(/^[A-Z]{2}[0-9]{6}(?:00|50)$/g).test($(this).val())){
                		//alert("發票號碼錯誤");
                		$(this).css("color","red");
                	}else{
                		$(this).css("color","black");
                	}
                });

                $('#txtEinvono').focus(function(e){
                	$(this).css("color","black");
                }).blur(function(e) {
                	$(this).val($.trim($(this).val().toUpperCase()));
                	if(!(/^[A-Z]{2}[0-9]{6}(?:49|99)$/g).test($(this).val())){
                		//alert("發票號碼錯誤");
                		$(this).css("color","red");
                	}else{
                		$(this).css("color","black");
                	}
                });

                $('#btnSeq').click(function(e) {
                	if(!(q_cur==1 || q_cur==2))
                		return;
                	var t_binvono = $('#txtBinvono').val(), t_einvono = $('#txtEinvono').val();
                	if(!(/^[A-Z]{2}[0-9]{6}(?:00|50)$/g).test(t_binvono) || !(/^[A-Z]{2}[0-9]{6}(?:49|99)$/g).test(t_einvono) ){
                		alert(q_getMsg('lblInvono') + '錯誤。');
                		return;
                	}
                	var n = parseInt(t_einvono.substring(2,10)) - parseInt(t_binvono.substring(2,10)) + 1;
   					if(n%50 != 0){
   						alert("發票號碼區間異常。");
   						return;
   					}
                	for ( i = 0; i < q_bbsCount; i++) {
                    	_btnMinus("btnMinus_" + i);
                    }   
                    while(q_bbsCount < n/50){
                    	$('#btnPlus').click();
                    }
                    var t_invono = t_binvono, t_string = '';                
                    for( i = 1; i <= n/50; i++){
                    	t_string = ('00' + i);
                    	t_string = t_string.substring(t_string.length-2,t_string.length);
                    	$('#txtNo2_'+(i-1)).val(t_string);
                    	if(i==1)
                    		$('#txtBinvono_'+(i-1)).val(t_invono);
                    	else{
                    		t_string = ('000000' + (parseInt(t_invono.substring(2,10)) + 1));
	                    	t_string = t_binvono.substring(0,2) + t_string.substring(t_string.length-8,t_string.length);
	                    	t_invono = t_string; 
	                    	$('#txtBinvono_'+(i-1)).val(t_invono);
                    	}
                    	t_string = ('000000' + (parseInt(t_invono.substring(2,10)) + 49));
                    	t_string = t_binvono.substring(0,2) + t_string.substring(t_string.length-8,t_string.length);
                    	t_invono = t_string;                	
                    	$('#txtEinvono_'+(i-1)).val(t_invono);
                    }
                });
                
                
                $('#btnE0401').click(function(e){
					var t_noa = $.trim($('#txtNoa').val());
					if(t_noa.length==0){
						
					}else{
						q_box("generateE0401.aspx?db="+q_db+"&bno="+t_noa+"&eno="+t_noa, "generateE0401", "95%", "95%", '');
					}
				});
				$('#btnE0402').click(function(e){
					var t_noa = $.trim($('#txtNoa').val());
					if(t_noa.length==0){
						
					}else{
						q_box("generateE0402.aspx?db="+q_db+"&bno="+t_noa+"&eno="+t_noa, "generateE0402", "95%", "95%", '');
					}
				});
				$('#btnE0501').click(function(e){
					var t_noa = $.trim($('#txtNoa').val());
					if(t_noa.length==0){
						
					}else{
						q_box("generateE0501.aspx?db="+q_db+"&bno="+t_noa+"&eno="+t_noa, "generateE0501", "95%", "95%", '');
					}
				});
				
				$('#cmbInvoicetype').change(function() {
					$('#chkIselectric').prop('checked',false);
	               	switch($.trim($('#cmbInvoicetype').val())){
	            		case '01':
	            			$('#txtRev').val('3');
	            			break;
	        			case '02':
	            			$('#txtRev').val('2');
	            			break;
	            		case '05':
	            			$('#chkIselectric').prop('checked',true);
	            			break;
	            		default:
	            			$('#txtRev').val('');
	            			$('#chkIselectric').prop('checked',false);
	            			break;
	            	}
				});
            }

            function q_boxClose(s2) {
                var ret;
                switch (b_pop) {
                    case q_name + '_s':
                        q_boxClose2(s2);
                        ///   q_boxClose 3/4
                        break;
                }   /// end Switch
            }

            function q_gtPost(t_name) {
                switch (t_name) {
                	case 'getInvoicetype':
                		var as = _q_appendData("invoicetype", "", true);
                		if (as[0] != undefined){
                			t_invoicetype = '@';
                			for(var i=0;i<as.length;i++){
                				t_invoicetype += (t_invoicetype.length>0?',':'') + as[i].noa+'@'+as[i].namea;
                			}
                		}
                		q_gt(q_name, q_content, q_sqlCount, 1);
                		break;
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                        break;
                    default:
                    	if(t_name.substring(0,11)=='checkInvono'){
                    		var n = parseFloat(t_name.split('_')[1]); 
                    		var as = _q_appendData("vccars", "", true);
	                        if (as[0] != undefined){
	                        	for(var i =0;i<as.length;i++){
	                        		if(as[i].noa!=$('#txtNoa').val()){
	                        			if(as[i].binvono == $('#txtBinvono_'+n).val()){
		                            		alert(as[i].einvono+'已存在。單號【'+as[i].noa+'】');
		                            		Unlock();
	                            			return;
		                            	}else if(as[i].einvono == $('#txtEinvono_'+n).val()){
		                            		alert(as[i].einvono+'已存在。單號【'+as[i].noa+'】');
		                            		Unlock();
	                            			return;
		                            	}else{
		                            		alert('例外錯誤。 n='+n);
		                            		Unlock();
	                            			return;
		                            	}
	                        		}
	                            }
	                        }
	                        chkInvono(n-1);
                    	}
                    	break;
                }  /// end switch
            }

            function sum() {
                var t1 = 0, t_unit, t_mount, t_weight = 0, t_count = 0;
                for (var j = 0; j < q_bbsCount; j++) {
                    if (!emp($('#txtNo2_' + j).val()))
                        t_count++;
                }// j
                $('#txtSeq').val(t_count);
            }

            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)// 1-3
                    return;

                q_box('vccar_s.aspx', q_name + '_s', "550px", "400px", q_getMsg("popSeek"));
            }

            function btnIns() {
                _btnIns();
                $('#txtNoa').val('AUTO');
                $('#txtNoa').focus();
            }

            function btnModi() {
                if (emp($('#txtNoa').val()))
                    return;

                _btnModi();
                $('#txtCno').focus();
                
                //rev由 invoicetype取代,由於相容性rev仍會寫入值
                if($('#cmbInvoicetype').val().length==0){
                	switch($.trim($('#txtRev').val())){
                		case '3':
                			$('#cmbInvoicetype').val('01');
                			break;
            			case '2':
                			$('#cmbInvoicetype').val('02');
                			break;
                		default:
                			break;
                	}
                	
                	//電子計算機
                	if($('#chkIselectric').prop('checked')){
                		$('#cmbInvoicetype').val('05');
                	}
                }
            }

            function btnPrint() {
                q_box('z_vccarp.aspx', '', "95%", "95%", q_getMsg("popPrint"));
            }

            function btnOk() {
            	Lock();
            	if($.trim($('#cmbInvoicetype').val()).length==0){
            		alert('請設定'+$('#lblInvoicetype').text());
            		Unlock();
            		return;
            	}
            	//rev由 invoicetype取代,由於相容性rev仍會寫入值
            	$('#chkIselectric').prop('checked',false);
            	
               	switch($.trim($('#cmbInvoicetype').val())){
            		case '01':
            			$('#txtRev').val('3');
            			break;
        			case '02':
            			$('#txtRev').val('2');
            			break;
            		case '05':
            			$('#chkIselectric').prop('checked',true);
            			break;
            		default:
            			$('#txtRev').val('');
            			$('#chkIselectric').prop('checked',false);
            			break;
            	}
               
                
                $('#txtBdate').val($.trim($('#txtBdate').val()));
                if (checkId($('#txtBdate').val()) == 0) {
                    alert(q_getMsg('lblBdate') + '錯誤。');
                    Unlock();
                    return;
                }
                $('#txtEdate').val($.trim($('#txtEdate').val()));
                if (checkId($('#txtEdate').val()) == 0) {
                    alert(q_getMsg('lblBdate') + '錯誤。');
                    Unlock();
                    return;
                }
                if($.trim($('#txtBinvono').val()).length==0 || $.trim($('#txtEinvono').val()).length==0){
                	alert(q_getMsg('lblInvono') + '錯誤。');
                    Unlock();
                    return;
                }
                //檢查BBS有無錯誤
                t_minInvono = 999999999;
                t_maxInvono = -1;
				for (var i = 0; i < q_bbsCount; i++) {
					if($('#txtBinvono_'+i).val().length>0)
						if($('#txtBinvono_'+i).val().substring(0,2)!=$('#txtBinvono').val().substring(0,2)){
							alert('異常：請重新產生本數。');
		                    Unlock();
		                    return;
						}else
							t_minInvono = Math.min(t_minInvono,parseFloat($('#txtBinvono_'+i).val().substring(2,10)));
					if($('#txtEinvono_'+i).val().length>0)
						if($('#txtEinvono_'+i).val().substring(0,2)!=$('#txtEinvono').val().substring(0,2)){
							alert('異常：請重新產生本數。');
		                    Unlock();
		                    return;
						}else
							t_maxInvono = Math.max(t_maxInvono,parseFloat($('#txtEinvono_'+i).val().substring(2,10)));
				}  
				if(t_minInvono!=parseFloat($('#txtBinvono').val().substring(2,10)) || t_maxInvono!=parseFloat($('#txtEinvono').val().substring(2,10)) ){
					alert('異常：請重新產生本數。');
                    Unlock();
                    return;
				}
                sum();
                //檢查BBS有無重覆
                chkInvono(q_bbsCount-1);
            }
            function chkInvono(n){
            	if(n<0){
            		var t_noa = trim($('#txtNoa').val());
	                var t_bdate = trim($('#txtBdate').val());
	                if (t_noa.length == 0 || t_noa == "AUTO")
	                    q_gtnoa(q_name, replaceAll((t_bdate.length == 0 ? q_bdate() : t_bdate), '/', ''));
	                else
	                    wrServer(t_noa);
            	}else{
            		t_where="where=^^ binvono='"+$('#txtBinvono_'+n).val()+"' or einvono='"+$('#txtEinvono_'+n).val()+"' ^^";
                    q_gt('vccars', t_where, 0, 0, 0, "checkInvono_"+n, r_accy);
            	}
            }
            function q_stPost() {
                if (!(q_cur == 1 || q_cur == 2))
                    return false;
                Unlock();
            }

            function bbsAssign() {
                for (var i = 0; i < q_bbsCount; i++) {
                    if (!$('#btnMinus_' + i).hasClass('isAssign')) {
                        $('#txtBinvono_' + i).change(function() {
                        });
                        $('#txtEinvono_' + i).change(function() {
                        });
                    }
                }
                _bbsAssign();
            }

            function wrServer(key_value) {
                var i;

                xmlSql = '';
                if (q_cur == 2)/// popSave
                    xmlSql = q_preXml();

                $('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
                _btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
            }

            function bbsSave(as) {
                if (!as['no2']) {
                    as[bbsKey[1]] = '';
                    return;
                }
                q_nowf();
                return true;
            }

            function refresh(recno) {
                _refresh(recno);
				$('#txtBinvono').css("color","black");
				$('#txtEinvono').css("color","black");
				
				if(q_getPara('sys.project').toUpperCase()=='XY'){
					$('.isrev').show()
				}
            }

            function readonly(t_para, empty) {
                _readonly(t_para, empty);
                if(q_cur == 1 || q_cur == 2 )
                	$('#btnSeq').removeAttr('disabled');
               	else
                	$('#btnSeq').attr('disabled','disabled');
            }

            function btnMinus(id) {
                _btnMinus(id);
            }

            function btnPlus(org_htm, dest_tag, afield) {
                _btnPlus(org_htm, dest_tag, afield);
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
            function checkId(str) {
                if ((/^[a-z,A-Z][0-9]{9}$/g).test(str)) {//身分證字號
                    var key = 'ABCDEFGHJKLMNPQRSTUVXYWZIO';
                    var s = (key.indexOf(str.substring(0, 1)) + 10) + str.substring(1, 10);
                    var n = parseInt(s.substring(0, 1)) * 1 + parseInt(s.substring(1, 2)) * 9 + parseInt(s.substring(2, 3)) * 8 + parseInt(s.substring(3, 4)) * 7 + parseInt(s.substring(4, 5)) * 6 + parseInt(s.substring(5, 6)) * 5 + parseInt(s.substring(6, 7)) * 4 + parseInt(s.substring(7, 8)) * 3 + parseInt(s.substring(8, 9)) * 2 + parseInt(s.substring(9, 10)) * 1 + parseInt(s.substring(10, 11)) * 1;
                    if ((n % 10) == 0)
                        return 1;
                } else if ((/^[0-9]{8}$/g).test(str)) {//統一編號
                    var key = '12121241';
                    var n = 0;
                    var m = 0;
                    for (var i = 0; i < 8; i++) {
                        n = parseInt(str.substring(i, i + 1)) * parseInt(key.substring(i, i + 1));
                        m += Math.floor(n / 10) + n % 10;
                    }
                    if ((m % 10) == 0 || ((str.substring(6, 7) == '7' ? m + 1 : m) % 10) == 0)
                        return 2;
                } else if ((/^[0-9]{4}\/[0-9]{2}\/[0-9]{2}$/g).test(str)) {//西元年
                    var regex = new RegExp("^(?:(?:([0-9]{4}(-|\/)(?:(?:0?[1,3-9]|1[0-2])(-|\/)(?:29|30)|((?:0?[13578]|1[02])(-|\/)31)))|([0-9]{4}(-|\/)(?:0?[1-9]|1[0-2])(-|\/)(?:0?[1-9]|1\\d|2[0-8]))|(((?:(\\d\\d(?:0[48]|[2468][048]|[13579][26]))|(?:0[48]00|[2468][048]00|[13579][26]00))(-|\/)0?2(-|\/)29))))$");
                    if (regex.test(str))
                        return 3;
                } else if ((/^[0-9]{3}\/[0-9]{2}\/[0-9]{2}$/g).test(str)) {//民國年
                    str = (parseInt(str.substring(0, 3)) + 1911) + str.substring(3);
                    var regex = new RegExp("^(?:(?:([0-9]{4}(-|\/)(?:(?:0?[1,3-9]|1[0-2])(-|\/)(?:29|30)|((?:0?[13578]|1[02])(-|\/)31)))|([0-9]{4}(-|\/)(?:0?[1-9]|1[0-2])(-|\/)(?:0?[1-9]|1\\d|2[0-8]))|(((?:(\\d\\d(?:0[48]|[2468][048]|[13579][26]))|(?:0[48]00|[2468][048]00|[13579][26]00))(-|\/)0?2(-|\/)29))))$");
                    if (regex.test(str))
                        return 4
                }
                return 0;
                //錯誤
            }

		</script>
		<style type="text/css">
            #dmain {
                overflow: hidden;
            }
            .dview {
                float: left;
                width: 400px;
                border-width: 0px;
            }
            .tview {
                border: 5px solid gray;
                font-size: medium;
                background-color: black;
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
                width: 650px;
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
                width: 2%;
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
                width: 1260px;
            }
            .tbbs a {
                font-size: medium;
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
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();">
		<!--#include file="../inc/toolbar.inc"-->
		<div id='dmain' >
			<div class="dview" id="dview">
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td align="center" style="width:100px; color:black;"><a id='vewAcomp'> </a></td>
						<td align="center" style="width:100px; color:black;"><a id='vewBdate'> </a></td>
						<td align="center" style="width:180px; color:black;"><a id='vewBinvono'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox" /></td>
						<td id="nick" style="text-align: center;">~nick</td>
						<td id="bdate" style="text-align: center;">~bdate</td>
						<td id="binvono" style="text-align: center;">~binvono</td>
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
						<td class="tdZ"> </td>
					</tr>
					<tr>
						<td><span> </span><a id="lblNoa" class="lbl"> </a></td>
						<td><input id="txtNoa"  type="text"  class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCno" class="lbl btn"> </a></td>
						<td colspan="3">
							<input id="txtCno"  type="text"  style="float:left;width:25%;"/>
							<input id="txtAcomp"  type="text" style="float:left;width:75%;"/>
							<input id="txtNick"  type="text" style="display:none;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblBdate" class="lbl"> </a></td>
						<td colspan="3">
							<input id="txtBdate"  type="text" style="float:left;width:47.5%;"/>
							<a id="lblSymbol1" style="float:left;width:5%;"> </a>
							<input id="txtEdate"  type="text" style="float:left;width:47.5%;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id="lblInvono" class="lbl"> </a></td>
						<td colspan="3">
							<input id="txtBinvono" type="text" style="float:left;width:47.5%;"/>
							<a id="lblSymbol2" style="float:left;width:5%;"> </a>
							<input id="txtEinvono" type="text" style="float:left;width:47.5%;"/>
						</td>
						
					</tr>
					<tr>
						<td><span> </span><a id="lblInvoicetype" class="lbl">發票類別</a></td>
						<td><select id="cmbInvoicetype" class="txt c1" style="width: 210px;"> </select></td>
						<!-- rev 由 invoicetype取代,由於相容性rev仍會寫入值 -->
						<td class="isrev" style="display:none;"><span> </span><a id="lblRev1" class="lbl"> </a></td>
						<td class="isrev" style="display:none;"><input id="txtRev"  type="text"  class="txt c1"/></td>
						<td> </td>
						<td>
							<input class="btn"  id="btnSeq" type="button"/>
							<input id="txtSeq" type="text" style="display:none;"/>
							<input id="chkIselectric" type="checkbox" style="display:none;" />
						</td>
					</tr>
				</table>
			</div>
			<input type="button" class="einvoice" id="btnE0401" value="[E0401]分支機構配號檔" style="float:left;width:200px;height:50px;white-space:normal;display:none;"/>
			<input type="button" class="einvoice" id="btnE0402" value="[E0402]空白未使用字軌檔" style="float:left;width:200px;height:50px;white-space:normal;display:none;"/>
			<input type="button" class="einvoice" id="btnA0501" value="[E0501]營業人電子發票配號檔" style="float:left;width:200px;height:50px;white-space:normal;display:none;"/>
		</div>
		<div class='dbbs'>
			<table id="tbbs" class='tbbs'>
				<tr style='color:white; background:#003366;' >
					<td  align="center" style="width:30px;">
					<input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  />
					</td>
					<td align="center" style="width:50px;"><a id='lblNo2'> </a></td>
					<td align="center" style="width:300px;"><a id='lblInvonos'> </a></td>
					<td align="center" style="width:200px;"><a id='lblPart'> </a></td>
					<td align="center" style="width:200px;"><a id='lblCust'> </a></td>
					<td align="center" style="width:100px;"><a id='lblDatea'> </a></td>
					<td align="center" style="width:200px;"><a id='lblMemo'> </a></td>
				</tr>
				<tr style='background:#cad3ff;'>
					<td align="center">
					<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
					</td>
					<td><input type="text" id="txtNo2.*" style="width:95%;text-align:center;"/></td>
					<td>
						<input id="txtBinvono.*"  type="text" style="float:left;width: 130px;"/>
						<a id="lblSymbol3" style="float:left;width: 20px;"> </a>
						<input id="txtEinvono.*"  type="text" style="float:left;width: 130px;"/>
					</td>
					<td>
						<input class="btn"  id="btnPart.*" type="button" value='.' style=" font-weight: bold;width:1%;float: left;" />
						<input type="text" id="txtPartno.*" style="width: 35%;float: left;"/>
						<input type="text" id="txtPart.*"  style="width: 53%;float: left;"/>
					</td>
					<td>
						<input class="btn"  id="btnCust.*" type="button" value='.' style=" font-weight: bold;width:1%;float: left;" />
						<input type="text" id="txtCustno.*" style="width: 25%;float: left;"/>
						<input type="text" id="txtComp.*"  style="width: 63%;float: left;"/>
					</td>
					<td><input type="text" id="txtDatea.*" style="width:95%;"/></td>
					<td>
						<input type="text" id="txtMemo.*" style="width:95%;"/>
						<input type="text" id="txtNoq.*" style="display:none;"/>
					</td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
	</body>
</html>
