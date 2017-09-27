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

			q_tables = 't';
			var q_name = "vcca";
			var q_readonly = ['txtMoney', 'txtTotal', 'txtChkno', 'txtTax', 'txtAccno', 'txtWorker', 'txtTrdno', 'txtVccno'
				,'chkIssend','chkIssendconfirm','chkIscancel','chkIscancelconfirm','txtRandnumber'];
			var q_readonlys = [];
			var q_readonlyt = ['txtVccaccy','txtVccno','txtVccnoq'];
			var bbmNum = [['txtMoney', 15, 0,1], ['txtTax', 15, 0,1], ['txtTotal', 15, 0,1]];
			var bbsNum = [['txtMount', 15, 3,1], ['txtGmount', 15, 4,1], ['txtEmount', 15, 4,1], ['txtPrice', 15, 3,1], ['txtTotal', 15, 0,1]];
			var bbtNum = [['txtMount', 15, 0, 1],['txtWeight', 15, 2, 1],['txtPrice', 15, 2, 1],['txtMoney', 15, 0, 1]];
			var bbmMask = [];
			var bbsMask = [];
			var bbtMask = [];
			q_sqlCount = 6;
			brwCount = 6;
			brwList = [];
			brwNowPage = 0;
			brwKey = 'Noa';
			aPop = new Array(['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx']
			, ['txtAddress', '', 'view_road', 'memo,zipcode', '0txtAddress,txtZip', 'road_b.aspx']
			, ['txtCustno', 'lblCust', 'cust', 'noa,comp,nick,serial,zip_invo,addr_invo', 'txtCustno,txtComp,txtNick,txtSerial,txtZip,txtAddress', 'cust_b.aspx']
			, ['txtBuyerno', 'lblBuyer', 'cust', 'noa,comp,serial', '0txtBuyerno,txtBuyer,txtSerial,txtMemo', 'cust_b.aspx']
			, ['txtSerial', 'lblSerial', 'vccabuyer', 'serial,noa,buyer', '0txtSerial,txtBuyerno,txtBuyer', 'vccabuyer_b.aspx']
			, ['txtProductno_', 'btnProductno_', 'ucca', 'noa,product,unit', 'txtProductno_,txtProduct_,txtUnit_', 'ucca_b.aspx']);
			q_xchg = 1;
			q_desc = 1;
			brwCount2 = 20;

			function currentData() {
			}
			currentData.prototype = {
				data : [],
				/*新增時複製的欄位*/
				//include : ['txtDatea', 'txtCno', 'txtAcomp', 'txtCustno', 'txtComp', 'txtNick', 'txtSerial', 'txtAddress', 'txtMon', 'txtNoa', 'txtBuyerno', 'txtBuyer'],
				include : ['txtDatea', 'txtCno', 'txtAcomp', 'txtMon', 'txtNoa'],
				/*記錄當前的資料*/
				copy : function() {
					curData.data = new Array();
					for (var i in fbbm) {
						var isInclude = false;
						for (var j in curData.include) {
							if (fbbm[i] == curData.include[j]) {
								isInclude = true;
								break;
							}
						}
						if (isInclude) {
							curData.data.push({
								field : fbbm[i],
								value : $('#' + fbbm[i]).val()
							});
						}
					}
				},
				/*貼上資料*/
				paste : function() {
					for (var i in curData.data) {
						$('#' + curData.data[i].field).val(curData.data[i].value);
					}
				}
			};
			var curData = new currentData();

			$(document).ready(function() {
				bbmKey = ['noa'];
				bbsKey = ['noa', 'noq'];
				bbtKey = ['noa', 'noq'];
				q_brwCount();
				q_gt(q_name, q_content, q_sqlCount, 1);
			});

			function main() {
				if (dataErr) {
					dataErr = false;
					return;
				}
				mainForm(1);
								
				if(q_getPara('sys.project').toUpperCase()!='VU2'){
					$('.isVU2').hide();
				}
			}

			function mainPost() {
				switch(q_getPara('sys.project').toUpperCase()){
					case 'RS':
						$('.einvoice').show();
						break;
				}
				
				switch(q_getPara('sys.project').toUpperCase()){
					case 'DC':
						cust_buyer();
						break;
					case 'WH':
						cust_buyer();
						break;
					case 'ES':
						cust_buyer();
						//HOT KEY
		                $('#btnIns').val('新增(alt+1)').css('white-space','normal').css('width','70px');
		                $('#btnModi').val('修改(alt+2)').css('white-space','normal').css('width','70px');
		                $('#btnDele').val('刪除(alt+3)').css('white-space','normal').css('width','70px');
		                $('#btnSeek').val('查詢(alt+4)').css('white-space','normal').css('width','70px');
		                $('#btnPrint').val('列印(alt+5)').css('white-space','normal').css('width','70px');
		                $('#btnPrevPage').val('翻上頁(alt+6)').css('white-space','normal').css('width','70px');
		                $('#btnPrev').val('上筆(alt+7)').css('white-space','normal').css('width','70px');
		                $('#btnNext').val('下筆(alt+8)').css('white-space','normal').css('width','70px');
		                $('#btnNextPage').val('翻下頁(alt+9)').css('white-space','normal').css('width','70px');
		                $('#btnOk').val('確定(F9)').css('white-space','normal').css('width','70px');
						break;
					case 'YC':
						bbsNum = [['txtMount', 15, 3], ['txtGmount', 15, 4], ['txtEmount', 15, 4], ['txtPrice', 15, 4], ['txtTotal', 15, 0]];
						break;
					case 'PK':
						bbsNum = [['txtMount', 15, 2, 1], ['txtGmount', 15, 2, 1], ['txtEmount', 15, 2, 1], ['txtPrice', 15, 4, 1], ['txtMoney', 15, 0, 1]];
						break;
					case 'XY':
						aPop = new Array(['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx']
							, ['txtAddress', '', 'view_road', 'memo,zipcode', '0txtAddress,txtZip', 'road_b.aspx']
							, ['txtCustno', 'lblCust', 'cust', 'noa,comp,nick,serial,zip_invo,addr_invo,invoicetitle', 'txtCustno,txtComp,txtNick,txtSerial,txtZip,txtAddress,txtBuyer', 'cust_b.aspx']
							, ['txtBuyerno', 'lblBuyer', 'cust', 'noa,comp,serial', '0txtBuyerno,txtBuyer,txtSerial,txtMemo', 'cust_b.aspx']
							, ['txtSerial', 'lblSerial', 'vccabuyer', 'serial,noa,buyer', '0txtSerial,txtBuyerno,txtBuyer', 'vccabuyer_b.aspx']
							, ['txtProductno_', 'btnProductno_', 'ucca', 'noa,product,unit', 'txtProductno_,txtProduct_,txtUnit_', 'ucca_b.aspx']);
						bbsNum = [['txtMount', 15, 3,1], ['txtGmount', 15, 4,1], ['txtEmount', 15, 4,1], ['txtPrice', 15, 4,1], ['txtTotal', 15, 0,1]];
						break;
					default:
						break;
				}
				q_getFormat();
				bbmMask = [['txtCanceldate', r_picd],['txtCanceltime', '99:99:99']
					, ['txtVoiddate', r_picd],['txtVoidtime', '99:99:99']
					, ['txtDatea', r_picd], ['txtMon', r_picm]];
				q_mask(bbmMask);
				q_xchgForm();
				q_xchgView(); //106/05/11 預設仍要先顯示vew (前面先執行到Form載入data再跳回VEW)
				q_cmbParse("cmbTaxtype", q_getPara('vcca.taxtype'));
				q_cmbParse("cmbPrintmark","N,Y");
				q_cmbParse("cmbCcm","@,1@非經海關出口,2@經海關出口");
				
				switch(q_getPara('sys.project').toUpperCase()){
					case 'VU':
						$('#chkAtax').show();
						break;
					default:
						break;	
				}
				
				if(q_db.toUpperCase()=="ST2"){
					$('.isST2').show();
				}
//*********************************************************************************************
				$('#btnA0101').click(function(e){
					if(q_xchg!=2){
						$('#btnXchg').click();
					}
					if($('#chkIssend').prop('checked')){
						alert('錯誤:已開立。');
						return;
					}
					if($('#chkIssendconfirm').prop('checked')){
						alert('錯誤:已開立接收確認。');
						return;
					}
					if($('#chkIscancel').prop('checked')){
						alert('錯誤:已產生作廢XML。');
						return;
					}
					if($('#chkIscancelconfirm').prop('checked')){
						alert('錯誤:已作廢接收確認。');
						return;
					}
					var t_invoiceNumber = $.trim($('#txtNoa').val());
					if(t_invoiceNumber.length==0){
						alert('錯誤:無單號');
						return;
					}
					if (!confirm("確認開立發票?")) {
					    return;
					}
					$.ajax({
						invoiceNumber : t_invoiceNumber,
	                    url: "../einvoice/A0101g.aspx?invoice="+t_invoiceNumber,
	                    type: 'POST',
	                    data: '',
	                    dataType: 'text',
	                    //timeout: 10000,
	                    success: function(data){
	                    	tmp = JSON.parse(data);
	                    		if(tmp.status!='OK'){
	                    			alert(tmp.msg);	                    		
	                    		}else if(this.invoiceNumber==$.trim($('#txtNoa').val())){
	                    			$('#chkIssend').prop('checked',true);
	                    			alert(tmp.invoice[0].Main.InvoiceNumber+" 開立完成。");	
	                    		}
	                    },
	                    complete: function(){
	                    	              
	                    },
	                    error: function(jqXHR, exception) {
	                        var errmsg = this.url+' 異常。\n';
	                        if (jqXHR.status === 0) {
	                            alert(errmsg+'Not connect.\n Verify Network.');
	                        } else if (jqXHR.status == 404) {
	                            alert(errmsg+'Requested page not found. [404]');
	                        } else if (jqXHR.status == 500) {
	                            alert(errmsg+'Internal Server Error [500].');
	                        } else if (exception === 'parsererror') {
	                            alert(errmsg+'Requested JSON parse failed.');
	                        } else if (exception === 'timeout') {
	                            alert(errmsg+'Time out error.');
	                        } else if (exception === 'abort') {
	                            alert(errmsg+'Ajax request aborted.');
	                        } else {
	                            alert(errmsg+'Uncaught Error.\n' + jqXHR.responseText);
	                        }
	                    }
	                });
				});
				
				$('#btnA0201').click(function(e){
					if(q_xchg!=2){
						$('#btnXchg').click();
					}
					if($('#cmbTaxtype').val()!='6'){
						alert('錯誤:發票未修改為作廢。');
						return;
					}
					if($.trim($('#txtCanceldate').val()).length==0){
						alert('錯誤:請輸入作廢日期。');
						return;
					}
					if($.trim($('#txtCanceltime').val()).length==0){
						alert('錯誤:請輸入作廢時間。');
						return;
					}
					if($('#chkIscancel').prop('checked')){
						alert('錯誤:已產生作廢XML。');
						return;
					}
					var t_invoiceNumber = $.trim($('#txtNoa').val());
					if(t_invoiceNumber.length==0){
						alert('錯誤:無單號');
						return;
					}
					if (!confirm("確認作廢發票?")) {
					    return;
					}
					$.ajax({
						invoiceNumber: t_invoiceNumber,
	                    url: "../einvoice/A0201g.aspx?invoice="+t_invoiceNumber,
	                    type: 'POST',
	                    data: '',
	                    dataType: 'text',
	                    //timeout: 10000,
	                    success: function(data){
	                    	try{
	                    		tmp = JSON.parse(data);
	                    		if(tmp.status!='OK'){
	                    			alert(tmp.msg);	                    		
	                    		}else if(this.invoiceNumber==$.trim($('#txtNoa').val())){
	                    			$('#chkIscancel').prop('checked',true);
	                    			$('#cmbTaxtype').val('6');
	                    			$('#txtTotal').val(0);
	                    			for(var i=0;i<q_bbsCount;i++){
	                    				$('#txtMoney_'+i).val(0);
	                    			}
	                    			alert('OK');	
	                    		}
	                    	}catch(e){
	                    	}
	                    },
	                    complete: function(){
	                    	              
	                    },
	                    error: function(jqXHR, exception) {
	                        var errmsg = this.url+' 異常。\n';
	                        if (jqXHR.status === 0) {
	                            alert(errmsg+'Not connect.\n Verify Network.');
	                        } else if (jqXHR.status == 404) {
	                            alert(errmsg+'Requested page not found. [404]');
	                        } else if (jqXHR.status == 500) {
	                            alert(errmsg+'Internal Server Error [500].');
	                        } else if (exception === 'parsererror') {
	                            alert(errmsg+'Requested JSON parse failed.');
	                        } else if (exception === 'timeout') {
	                            alert(errmsg+'Time out error.');
	                        } else if (exception === 'abort') {
	                            alert(errmsg+'Ajax request aborted.');
	                        } else {
	                            alert(errmsg+'Uncaught Error.\n' + jqXHR.responseText);
	                        }
	                    }
	                });
				});
				
				$('#btnA0401').click(function(e){
					if(q_xchg!=2){
						$('#btnXchg').click();
					}
					if($('#chkIssend').prop('checked')){
						alert('錯誤:已開立。');
						return;
					}
					if($('#chkIssendconfirm').prop('checked')){
						alert('錯誤:已開立接收確認。');
						return;
					}
					if($('#chkIscancel').prop('checked')){
						alert('錯誤:已產生作廢XML。');
						return;
					}
					if($('#chkIscancelconfirm').prop('checked')){
						alert('錯誤:已作廢接收確認。');
						return;
					}
					var t_invoiceNumber = $.trim($('#txtNoa').val());
					if(t_invoiceNumber.length==0){
						alert('錯誤:無單號');
						return;
					}
					if (!confirm("確認開立發票?")) {
					    return;
					}
					$.ajax({
						invoiceNumber : t_invoiceNumber,
	                    url: "../einvoice/A0401g.aspx?invoice="+t_invoiceNumber,
	                    type: 'POST',
	                    data: '',
	                    dataType: 'text',
	                    //timeout: 10000,
	                    success: function(data){
	                    	tmp = JSON.parse(data);
	                    		if(tmp.status!='OK'){
	                    			alert(tmp.msg);	                    		
	                    		}else if(this.invoiceNumber==$.trim($('#txtNoa').val())){
	                    			$('#chkIssend').prop('checked',true);
	                    			$('#chkIssendconfirm').prop('checked',true);
	                    			alert(tmp.invoice[0].Main.InvoiceNumber+" 開立完成。");	
	                    		}
	                    },
	                    complete: function(){
	                    	              
	                    },
	                    error: function(jqXHR, exception) {
	                        var errmsg = this.url+' 異常。\n';
	                        if (jqXHR.status === 0) {
	                            alert(errmsg+'Not connect.\n Verify Network.');
	                        } else if (jqXHR.status == 404) {
	                            alert(errmsg+'Requested page not found. [404]');
	                        } else if (jqXHR.status == 500) {
	                            alert(errmsg+'Internal Server Error [500].');
	                        } else if (exception === 'parsererror') {
	                            alert(errmsg+'Requested JSON parse failed.');
	                        } else if (exception === 'timeout') {
	                            alert(errmsg+'Time out error.');
	                        } else if (exception === 'abort') {
	                            alert(errmsg+'Ajax request aborted.');
	                        } else {
	                            alert(errmsg+'Uncaught Error.\n' + jqXHR.responseText);
	                        }
	                    }
	                });
				});
				
				$('#btnA0501').click(function(e){
					if(q_xchg!=2){
						$('#btnXchg').click();
					}
					if($('#cmbTaxtype').val()!='6'){
						alert('錯誤:發票未修改為作廢。');
						return;
					}
					if($.trim($('#txtCanceldate').val()).length==0){
						alert('錯誤:請輸入作廢日期。');
						return;
					}
					if($.trim($('#txtCanceltime').val()).length==0){
						alert('錯誤:請輸入作廢時間。');
						return;
					}
					if($('#chkIscancel').prop('checked')){
						alert('錯誤:已產生作廢XML。');
						return;
					}
					var t_invoiceNumber = $.trim($('#txtNoa').val());
					if(t_invoiceNumber.length==0){
						alert('錯誤:無單號');
						return;
					}
					if (!confirm("確認作廢發票?")) {
					    return;
					}
					$.ajax({
						invoiceNumber : t_invoiceNumber,
	                    url: "../einvoice/A0501g.aspx?invoice="+t_invoiceNumber,
	                    type: 'POST',
	                    data: '',
	                    dataType: 'text',
	                    //timeout: 10000,
	                    success: function(data){
	                    	tmp = JSON.parse(data);
	                    		if(tmp.status!='OK'){
	                    			alert(tmp.msg);	                    		
	                    		}else if(this.invoiceNumber==$.trim($('#txtNoa').val())){
	                    			$('#chkIscancel').prop('checked',true);
	                    			$('#chkIscancelconfirm').prop('checked',true);
	                    			alert(this.invoiceNumber+" 作廢完成。");	
	                    		}
	                    },
	                    complete: function(){
	                    	              
	                    },
	                    error: function(jqXHR, exception) {
	                        var errmsg = this.url+' 異常。\n';
	                        if (jqXHR.status === 0) {
	                            alert(errmsg+'Not connect.\n Verify Network.');
	                        } else if (jqXHR.status == 404) {
	                            alert(errmsg+'Requested page not found. [404]');
	                        } else if (jqXHR.status == 500) {
	                            alert(errmsg+'Internal Server Error [500].');
	                        } else if (exception === 'parsererror') {
	                            alert(errmsg+'Requested JSON parse failed.');
	                        } else if (exception === 'timeout') {
	                            alert(errmsg+'Time out error.');
	                        } else if (exception === 'abort') {
	                            alert(errmsg+'Ajax request aborted.');
	                        } else {
	                            alert(errmsg+'Uncaught Error.\n' + jqXHR.responseText);
	                        }
	                    }
	                });
				});
				
				$('#btnVccb').click(function(e){
					if(q_xchg!=2){
						$('#btnXchg').click();
					}
					t_vcca = {
						table:'VCCA',
						noa:$.trim($('#txtNoa').val()),
						datea:$.trim($('#txtDatea').val()),
						cno:$.trim($('#txtCno').val()),
						acomp:$.trim($('#txtAcomp').val()),
						serial:$.trim($('#txtSerial').val()),
						custno:$.trim($('#txtCustno').val()),
						comp:$.trim($('#txtComp').val()),
						nick:$.trim($('#txtNick').val()),
						address:$.trim($('#txtAddress').val()),
						taxtype:$.trim($('#cmbTaxtype').val()),
						taxrate:q_float('txtTaxrate'),
						money:q_float('txtMoney'),
						tax:q_float('txtTax'),
						total:q_float('txtTotal'),
						bbs:[]
					};
					for(var i=0;i<q_bbsCount;i++){
						t_vcca.bbs.push({
							productno:$.trim($('#txtProductno_'+i).val()),
							product:$.trim($('#txtProduct_'+i).val()),
							unit:$.trim($('#txtUnit_'+i).val()),
							mount:q_float('txtMount_'+i),
							price:q_float('txtPrice_'+i),
							money:q_float('txtMoney_'+i),
						});
						
					}
					
					t_where = " exists(select noa from vccbs where vccbs.noa=vccb.noa and charindex('" + t_vcca.noa + "',vccbs.invono)>0)";
					q_box("vccb.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where+";"+";"+JSON.stringify({data:t_vcca}), "vccb", "95%", "95%", '');
				});
				
				$('#btnC0401').click(function(e){
					if(q_xchg!=2){
						$('#btnXchg').click();
					}
					if($('#chkIssend').prop('checked')){
						alert('錯誤:已開立。');
						return;
					}
					if($('#chkIssendconfirm').prop('checked')){
						alert('錯誤:已開立接收確認。');
						return;
					}
					if($('#chkIscancel').prop('checked')){
						alert('錯誤:已產生作廢XML。');
						return;
					}
					/*if($('cmbPrintmark').val()!='Y' && ){
						
						
					}*/
					if($('#chkIscancelconfirm').prop('checked')){
						alert('錯誤:已作廢接收確認。');
						return;
					}
					var t_invoiceNumber = $.trim($('#txtNoa').val());
					if(t_invoiceNumber.length==0){
						alert('錯誤:無單號');
						return;
					}
					if (!confirm("確認開立發票(B2C)?")) {
					    return;
					}
					$.ajax({
						invoiceNumber : t_invoiceNumber,
	                    url: "../einvoice/C0401.aspx?invoice="+t_invoiceNumber,
	                    type: 'POST',
	                    data: '',
	                    dataType: 'text',
	                    //timeout: 10000,
	                    success: function(data){
	                    	tmp = JSON.parse(data);
	                    		if(tmp.status!='OK'){
	                    			alert(tmp.msg);	                    		
	                    		}else if(this.invoiceNumber==$.trim($('#txtNoa').val())){
	                    			$('#chkIssend').prop('checked',true);
	                    			$('#chkIssendconfirm').prop('checked',true);
	                    			alert(tmp.invoice[0].Main.InvoiceNumber+" 開立完成。");	
	                    		}
	                    },
	                    complete: function(){
	                    	              
	                    },
	                    error: function(jqXHR, exception) {
	                        var errmsg = this.url+' 異常。\n';
	                        if (jqXHR.status === 0) {
	                            alert(errmsg+'Not connect.\n Verify Network.');
	                        } else if (jqXHR.status == 404) {
	                            alert(errmsg+'Requested page not found. [404]');
	                        } else if (jqXHR.status == 500) {
	                            alert(errmsg+'Internal Server Error [500].');
	                        } else if (exception === 'parsererror') {
	                            alert(errmsg+'Requested JSON parse failed.');
	                        } else if (exception === 'timeout') {
	                            alert(errmsg+'Time out error.');
	                        } else if (exception === 'abort') {
	                            alert(errmsg+'Ajax request aborted.');
	                        } else {
	                            alert(errmsg+'Uncaught Error.\n' + jqXHR.responseText);
	                        }
	                    }
	                });
				});
//*********************************************************************************************				
				
				
				$('#cmbTaxtype').focus(function() {
					var len = $("#cmbTaxtype").children().length > 0 ? $("#cmbTaxtype").children().length : 1;
					$("#cmbTaxtype").attr('size', len + "");
				}).blur(function() {
					$("#cmbTaxtype").attr('size', '1');
				}).change(function(e) {
					sum();
					refreshBbs();
				}).click(function(e) {
					sum();
					refreshBbs();
				});
				
				$('#txtNoa').change(function(e) {
					$('#txtNoa').val($('#txtNoa').val().toUpperCase());
					q_func('qtxt.query.checkdata', 'vcca.txt,checkdata,' +q_cur+';'+$('#txtNoa').val()+';'+$('#txtCno').val()+';'+$('#txtDatea').val());
				});
				$('#txtTax').change(function() {
					sum();
				});
				$('#chkAtax').change(function() {
					sum();
				});
				$('#txtMoney').change(function() {
					sum();
				});
				$('#lblAccno').click(function() {
					var t_year;
					if(q_getPara('sys.project').toUpperCase().substring(0,2)=='VU' && r_len=='4'){
						t_year=$('#txtDatea').val().substring(0, 4)-1911;
					}else{
						t_year=$('#txtDatea').val().substring(0, 3);
					}
					q_pop('txtAccno', "accc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";accc3='" + $('#txtAccno').val() + "';" + t_year + '_' + r_cno, 'accc', 'accc3', 'accc2', "92%", "1054px", q_getMsg('popAccc'), true);
				});
				$('#lblTrdno').click(function() {
					q_pop('txtTrdno', "trd.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $('#txtTrdno').val() + "';" + r_accy + '_' + r_cno, 'trd', 'noa', 'datea', "95%", "95%", q_getMsg('popTrd'), true);
				});
				$('#lblVccno').click(function() {
					t_vccno = $('#txtVccno').val();
					if(t_vccno.length>0){
						switch(q_getPara('sys.project').toUpperCase()){
							case 'IT':
								q_pop('txtVccno', "vcc_it.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $('#txtVccno').val() + "';" + ($('#txtDatea').val().substring(0, 3)<'101'?r_accy:$('#txtDatea').val().substring(0, 3)) + '_' + r_cno, 'vcc', 'noa', 'datea', "95%", "95%", q_getMsg('popVcc'), true);
								break;
							case 'BD':
								q_pop('txtVccno', "vccst.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $('#txtVccno').val() + "';" + r_accy + '_' + r_cno, 'vcc', 'noa', 'datea', "95%", "95%", q_getMsg('popVcc'), true);
								break;
							case 'VU':
								q_pop('txtVccno', "vcc_vu.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $('#txtVccno').val() + "';" + r_accy + '_' + r_cno, 'vcc', 'noa', 'datea', "95%", "95%", q_getMsg('popVcc'), true);
								break;
							case 'XY':
								q_pop('txtVccno', "vcc_xy.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";charindex(noa,'" + $('#txtVccno').val() + "')>0;" + r_accy + '_' + r_cno, 'vcc', 'noa', 'datea', "95%", "95%", q_getMsg('popVcc'), true);
								break;
							default:
								q_pop('txtVccno', "vcc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $('#txtVccno').val() + "';" + r_accy + '_' + r_cno, 'vcc', 'noa', 'datea', "95%", "95%", q_getMsg('popVcc'), true);
								break;	
						}
					}else{
						if (q_getPara('sys.project').toUpperCase()=='XY'){
							return;
						}
						if(q_cur==1 || q_cur==2){
							var t_vccano = $('#txtNoa').val();
							var t_custno = $('#txtCustno').val();
							var t_date = $('#txtDatea').val();
							
							if(q_getPara('sys.project').toUpperCase() == 'VU'){
								t_where = "b.typea!='2' and b.custno='"+t_custno+"' and (c.noa='"+t_vccano+"' or c.noa is null) ";
								t_where +="and b.datea>'2016/02/22' and (ISNULL(b.atax,0)=1 or isnull(b.tax,0)>0)";
								
								t_where +="^^";
								
								t_where += "where[1]=^^b.custno='"+t_custno+"' and (c.noa='"+t_vccano+"' or c.noa is null) ";
								t_where +="and (ISNULL(b.atax,0)=1 or isnull(b.tax,0)>0)^^";
								
								q_box("vccavcc_vu_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where+";"+";"+JSON.stringify({vccano:t_vccano,custno:t_custno}), "vccavcc", "95%", "95%", '');
							}else{
								t_where = "b.typea!='2' and b.custno='"+t_custno+"' and (c.noa='"+t_vccano+"' or c.noa is null) ";
								t_where +="and b.datea<='"+t_date+"'";
								q_box("vccavcc_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where+";"+";"+JSON.stringify({vccano:t_vccano,custno:t_custno}), "vccavcc", "95%", "95%", '');
							}
						}else{
							if(q_getPara('sys.project').toUpperCase() == 'VU'){
								return;
							}
							var t_noa = '';
							for(var i=0;i<q_bbtCount;i++){
								if($('#txtVccno__'+i).val().length>0)
									t_noa += (t_noa.length>0?" or ":"")+"noa='"+$('#txtVccno__'+i).val()+"'";
							}
							if(t_noa.length>0)
								q_box("vccst.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";"+t_noa + ";" + r_accy, 'vcc', "95%", "95%", q_getMsg("popVcc"));
						}
					}
				});
			}
			function  q_onkeydown(e){
				if(!e.altKey)
            		return;
            	if(q_getPara('sys.project').toUpperCase()=='ES')	
	            	switch(e.keyCode){
	            		case 49:
	            			if($('#btnIns').attr('disabled')!='disabled')
	            				$('#btnIns').click();
	            			break;
	        			case 50:
	        				if($('#btnModi').attr('disabled')!='disabled')
	        					$('#btnModi').click();
	            			break;
	        			case 51:
	        				if($('#btnDele').attr('disabled')!='disabled')
	        					$('#btnDele').click();
	            			break;
	        			case 52:
	        				if($('#btnSeek').attr('disabled')!='disabled')
	        					$('#btnSeek').click();
	            			break;
	        			case 53:
	        				if($('#btnPrint').attr('disabled')!='disabled')
	        					$('#btnPrint').click();
	            			break;
	        			case 54:
	        				if($('#btnPrevPage').attr('disabled')!='disabled')
	        					$('#btnPrevPage').click();
	            			break;
	        			case 55:
	        				if($('#btnPrev').attr('disabled')!='disabled')
	        					$('#btnPrev').click();
	            			break;
	        			case 56:
	        				if($('#btnNext').attr('disabled')!='disabled')
	        					$('#btnNext').click();
	            			break;
	        			case 57:
	        				if($('#btnNextPage').attr('disabled')!='disabled')
	        					$('#btnNextPage').click();
	            			break;
	        			/*case 48:
	        				if($('#btnOk').attr('disabled')!='disabled')
	        					$('#btnOk').click();
	            			break;*/
	            		default:
	            			break;
	            	}	
			}

			function q_boxClose(s2) {
				var ret;
				switch (b_pop) {
					case 'cust_buyer':
						if (b_ret != null) {
                        	as = b_ret;
                        	if(as[0]!=undefined){
                        		$('#txtBuyerno').val(as[0].buyerno);
                        		$('#txtBuyer').val(as[0].buyer);
                        		$('#txtSerial').val(as[0].serial);
                        		$('#txtZip').val(as[0].zip);
                        		$('#txtAddress').val(as[0].address);
                        	}
                        }
						break;
					case 'vccavcc':
                        if (b_ret != null) {
                        	$("#dbbt").show();
                        	as = b_ret;
                        	for(var i=0;i<q_bbtCount;i++){
                        		$('#btnMinut__'+i).click();
                        	}
                        	
                        	for(var i=0;i<as.length;i++){
								if(as[i].tablea==undefined){
									as[i].tablea='vccst';
								}
								if(as[i].uno==undefined){
									as[i].uno='';
								}
                        	}
                        	
                    		q_gridAddRow(bbtHtm, 'tbbt', 'txtTablea,txtVccaccy,txtVccno,txtVccnoq,txtUno,txtProduct,txtMount,txtWeight,txtPrice,txtMoney'
                        	, as.length, as, 'tablea,accy,noa,noq,uno,product,mount,weight,price,total', '','');
                        }else{
                        	Unlock(1);
                        }
                        break;
					case q_name + '_s':
						q_boxClose2(s2);
						break;
				}
				b_pop = '';
			}
			function q_popPost(s1) {
                switch (s1) {
                	case 'txtCustno':
                		$('#txtComp').val($('#txtComp').val().replace(/(.*)\+(.*)/,'$2'));
                		break;
                	case 'txtBuyerno':
                		$('#txtBuyer').val($('#txtBuyer').val().replace(/(.*)\+(.*)/,'$2'));
                		break;
                    case 'txtCno':
                        q_func('qtxt.query.checkdata', 'vcca.txt,checkdata,' +q_cur+';'+$('#txtNoa').val()+';'+$('#txtCno').val()+';'+$('#txtDatea').val());
                        break;
                	case 'txtProductno_':
                		var n = b_seq;
                		t_productno = $('#txtProductno_'+n).val();
                		t_date = $('#txtDatea').val();
                		if(t_productno.length>0 && q_getPara('sys.project').toUpperCase()!='VU' && q_getPara('sys.project').toUpperCase()!='YC' && q_getPara('sys.project').toUpperCase()!='XY' && q_getPara('sys.project').toUpperCase()!='SB')
                			q_func('qtxt.query.vcca_mount_'+n, 'vcca.txt,vcca_mount,'+$('#txtNoa').val()+';'+$('#txtCno').val()+';'+t_date+';'+t_productno);
                		
                		break;
                    default:
                        break;
                }
            }
			function q_funcPost(t_func, result) {
				switch(t_func) {
					case 'qtxt.query.vcca_apv':
                		var as = _q_appendData("tmp0", "", true);
                        if (as[0] != undefined) {
                        	if(as[0].val == 1){
                        		q_func('qtxt.query.checkdata_btnOk', 'vcca.txt,checkdata,' +q_cur+';'+$('#txtNoa').val()+';'+$('#txtCno').val()+';'+$('#txtDatea').val());	
                        	}else{
                        		alert(as[0].msg);
                        		Unlock(1);
                				return;
                        	}
                        }
                		break;
					case 'qtxt.query.checkdata':
						var as = _q_appendData("tmp0", "", true, true);
                		if(as[0]!=undefined){
                			if(as[0].val!='1'){
                				alert(as[0].msg);
                				Unlock(1);
                				return;
                			}
                		}
                		break;
					case 'qtxt.query.checkdata_btnOk':
						var as = _q_appendData("tmp0", "", true, true);
                		if(as[0]!=undefined){
                			if(as[0].val!='1'){
                				alert(as[0].msg);
                				Unlock(1);
                				return;
                			}
                		}
                		//鉅昕
                		//發票開立金額 不可大於該客戶當月出貨金額
						//項目有預收款排除
						var isExist = false;
						for(var i=0;i<q_bbsCount;i++){
							if($('#txtProduct_0').val().indexOf('預收')>=0){
								isExist = true;
								break;
							}
						}
						if(q_getPara('sys.project').toUpperCase()=='FE' && !isExist){
							q_func('qtxt.query.checkMoney', 'vcca.txt,checkMoney,'+$('#txtNoa').val()+';'+$('#txtCustno').val()+';'+$('#txtMon').val());	
						}else{
							wrServer($('#txtNoa').val());
						}
						break;
					case 'qtxt.query.checkMoney':
						var as = _q_appendData("tmp0", "", true, true);
                		if(as[0]!=undefined){
            				var t_money = q_float('txtMoney');
            				var t_vcca = parseFloat(as[0].vcca);
                			var t_vcc = parseFloat(as[0].vcc);
                			
                			if(t_money+t_vcca > t_vcc){
                				alert('本張發票金額'+t_money+' + 其他發票金額 '+t_vcca+'大於出貨金額 '+t_vcc);
                				//Unlock(1);
                				//return;
                			}
                		}
                		wrServer($('#txtNoa').val());
						break;
					default:
						if(t_func.substring(0,22)=='qtxt.query.vcca_mount_'){
							//檢查發票產品庫存(只有警告)
							var n = t_func.replace(/qtxt\u002Equery\u002Evcca\u005Fmount\u005F([0-9]+)/,'$1');
							var t_productno = $('#txtProductno_'+n).val();
							var t_date = $('#txtDatea').val();
							//var n = t_func.replace(/qtxt\u002Equery\u002Evcca\u005Fmount\u005F([0-9]+)\u005F(.+)/,'$1');
							//var t_date = t_func.replace(/qtxt\u002Equery\u002Evcca\u005Fmount\u005F([0-9]+)\u005F(.+)\u005F(.+)/,'$2');
							//var t_productno = t_func.replace(/qtxt\u002Equery\u002Evcca\u005Fmount\u005F([0-9]+)\u005F(.+)\u005F(.+)/,'$3');
							var t_mount = 0;//庫存
							
							var as = _q_appendData("tmp0", "", true, true);
	                		if(as[0]!=undefined){
	                			try{
	                				t_mount = parseFloat(as[0].mount);
	                			}catch(e){}
	                		}
	                		var t_curmount = 0;//本張發票數量
	                		for(var i=0;i<q_bbsCount;i++){
	                			if($('#txtProductno_'+i).val()==t_productno)
	                				t_curmount = q_add(t_curmount,q_float('txtMount_'+i));
	                		}
	                		switch(q_getPara('sys.project').toUpperCase()){
	                			case 'ES':
	                				//再興不檢查庫存
	                				break;
	                			default:
	                				if(t_curmount>t_mount){
			                			alert('產品【'+t_productno+'】'+t_date+' 庫存：'+t_mount);
			                		}
			                		break;
	                		}
						}
						break;
				}
			}
			function q_gtPost(t_name) {
				switch (t_name) {
					case 'getAcomp':
						var as = _q_appendData("acomp", "", true);
						if (as[0] != undefined) {
							if($('#txtCno').val().length == 0){
								$('#txtCno').val(as[0].noa);
								$('#txtAcomp').val(as[0].nick);
							}
						}
						Unlock(1);
						if(q_getPara('sys.project')=='fe'){
							//鉅昕發票找還沒開過的
							t_wehre = "where=^^['"+$('#txtCno').val()+"','"+$('#txtDatea').val()+"')^^";
							q_gt('getvccano', t_wehre, 0, 0, 0, 'getVccano', r_accy,true);
						}else{
							//發票號碼+1
							var t_noa = trim($('#txtNoa').val());
							var str = '00000000' + (parseInt(t_noa.substring(2, 10)) + 1);
							str = str.substring(str.length - 8, str.length);
							if (!isNaN(parseFloat(str)) && isFinite(str)) {
								t_noa = t_noa.substring(0, 2) + str;
								$('#txtNoa').val(t_noa);
							}
						}
						switch(q_getPara('sys.project').toUpperCase()){
							case 'PE':
								$('#txtCustno').focus();
								break;
							case 'ES':
								$('#txtCustno').focus();
								break;
							default:
								$('#txtDatea').focus();
								break;
						}
						break;
					case 'getVccano':
						var as = _q_appendData("getvccano", "", true);
						if (as[0] != undefined) {
							$('#txtNoa').val(as[0].invono);
						}
						break;
					case q_name:
						if (q_cur == 4)// 查詢
							q_Seek_gtPost();
						break;
				}
			}
			function q_stPost() {
				if (!(q_cur == 1 || q_cur == 2))
					return false;
				abbm[q_recno]['accno'] = xmlString.split(";")[0];
				abbm[q_recno]['chkno'] = xmlString.split(";")[1];
				$('#txtAccno').val(xmlString.split(";")[0]);
				$('#txtChkno').val(xmlString.split(";")[1]);
				Unlock(1);
				
                if(q_cur==1){
                	switch(q_getPara('sys.project').toUpperCase()){
                		case 'ES':
                			//存檔後自動新增
                			q_stModi=1;
                			$('#btnIns').click();	
                			break;
                		default:
                			break;
                	}
                }
			}

			function btnOk() {
				Lock(1, {
					opacity : 0
				});
				if($.trim($('#txtRandnumber').val()).length==0){
					//定義 [0-9,A][0-9,A][0-9,A][0-9,A]
					//var key = "0123456789A";
					//先用數字就好
					var key = "0123456789";
					var randNumber = "",n=0;
					for(var i=0;i<4;i++){
						n = Math.round(Math.random()*100)%key.length;
						randNumber += key.substring(n,n+1);
					}
					$('#txtRandnumber').val(randNumber);
				}
				if(/^0+$/.test($.trim($('txtSerial').val()))){
					//強制改為10個0
					$('txtSerial').val('0000000000');
				}
				if($('#chkDonatemark').prop('checked') && $('#txtNpoban').val().length==0){
					alert("發票捐贈對象必填");
					Unlock(1);
					return;
				}
				if($('#cmbTaxtype').val()=='2' && $('#cmbCcm').val().length==0){
					alert($('#lblCcm').text()+"：若為零稅率發票，此為必填欄位");
					Unlock(1);
					return;
				}
				
				if($('#cmbTaxtype').val()=='6' && $.trim($('#txtMemo').val()).length==0){
					alert('作廢需在"備註"填寫作廢原因。');
					Unlock(1);
					return;
				}
				var t_err = '';
				t_err = q_chkEmpField([['txtNoa', q_getMsg('lblNoa')], ['txtDatea', q_getMsg('lblDatea')], ['txtCno', q_getMsg('lblAcomp')]]);
				if (t_err.length > 0) {
					alert(t_err);
					Unlock(1);
					return;
				}
				
				if ($('#txtDatea').val().length == 0 || !q_cd($('#txtDatea').val())) {
					alert(q_getMsg('lblDatea') + '錯誤。');
					return;
				}
				
				$('#txtNoa').val($.trim($('#txtNoa').val()));
				
				if ($('#txtNoa').val().length > 0 && !(/^[a-z,A-Z]{2}[0-9]{8}$/g).test($('#txtNoa').val())) {
					alert(q_getMsg('lblNoa') + '錯誤。');
					Unlock(1);
					return;
				}
				
				if ($.trim($('#txtMon').val()).length == 0)
					$('#txtMon').val($('#txtDatea').val().substring(0, r_lenm));
					
				$('#txtMon').val($.trim($('#txtMon').val()));
				
				if ((!(/^[0-9]{3}\/(?:0?[1-9]|1[0-2])$/g).test($('#txtMon').val()) && r_lenm==6)
				|| (!(/^[0-9]{4}\/(?:0?[1-9]|1[0-2])$/g).test($('#txtMon').val()) && r_lenm==7)
				) {
					alert(q_getMsg('lblMon') + '錯誤。');
					Unlock(1);
					return;
				}
				
				$('#txtWorker').val(r_name);
				
				sum();
				//檢查發票抬頭
				if(q_getPara('sys.project').toUpperCase()=='FE'){
					//鉅昕印發票是印 COMP 那格,而不是買受人
					q_func('qtxt.query.vcca_apv', 'vcca.txt,vcca_apv,'+r_userno+';vcca;' + $('#btnOk').data('guid')+';'+$('#txtNoa').val()+';'+$('#txtCustno').val()+';'+$('#txtComp').val()+';'+$('#txtBuyer').val()+';'); 
				}else{
					q_func('qtxt.query.checkdata_btnOk', 'vcca.txt,checkdata,' +q_cur+';'+$('#txtNoa').val()+';'+$('#txtCno').val()+';'+$('#txtDatea').val());	
				}
			}

			function _btnSeek() {
				if (q_cur > 0 && q_cur < 4)// 1-3
					return;
				q_box('vcca_s.aspx', q_name + '_s', "550px", "450px", q_getMsg("popSeek"));
			}

			function bbsAssign() {/// 表身運算式
				for (var j = 0; j < q_bbsCount; j++) {
					$('#lblNo_' + j).text(j + 1);
					if (!$('#btnMinus_' + j).hasClass('isAssign')) {
						$('#chkAprice_'+j).click(function(e){refreshBbs();});
						$('#txtMount_' + j).change(function() {
							var n = $(this).attr('id').replace(/^(.*)_(\d+)$/,'$2');
							t_productno = $('#txtProductno_'+n).val();
	                		t_date = $('#txtDatea').val();
	                		if(t_productno.length>0 && q_getPara('sys.project').toUpperCase()!='VU'  && q_getPara('sys.project').toUpperCase()!='YC' && q_getPara('sys.project').toUpperCase()!='XY' && q_getPara('sys.project').toUpperCase()!='SB')
	                			q_func('qtxt.query.vcca_mount_'+n, 'vcca.txt,vcca_mount,'+$('#txtNoa').val()+';'+$('#txtCno').val()+';'+t_date+';'+t_productno);
							sum();
						});
						$('#txtPrice_' + j).change(function() {
							sum();
						});
						$('#txtMoney_' + j).change(function() {
							sum();
						});
					}
				}
				_bbsAssign();
				$('#tbbs').find('tr.data').children().hover(function(e){
					$(this).parent().css('background','#F2F5A9');
				},function(e){
					$(this).parent().css('background','#cad3ff');
				});
				refreshBbs();
				for (var j = 0; j < q_bbsCount; j++) {
					if (j>=7 && q_getPara('sys.project').toUpperCase()=='VU'){
						$('#tr_'+j).hide();
					}
				}
			}
			function bbtAssign() {
                for (var i = 0; i < q_bbtCount; i++) {
                    $('#lblNo__' + i).text(i + 1);
                    if (!$('#btnMinut__' + i).hasClass('isAssign')) {
                    	$('#txtVccno__'+i).bind('contextmenu',function(e) {
	                    	/*滑鼠右鍵*/
	                    	e.preventDefault();
	                    	var n = $(this).attr('id').replace('txtVccno__','');
	                    	var t_accy = $('#txtVccaccy__'+n).val();
	                    	var t_tablea = emp($('#txtTablea__'+n).val())?'vccst':$('#txtTablea__'+n).val();
	                    	
	                    	if (q_getPara('sys.project').toUpperCase()=='VU'){
	                    		if(t_tablea=='get')
	                    			q_box("get_vu.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $(this).val() + "';" + t_accy, t_tablea, "95%", "95%", q_getMsg("pop"+t_tablea));
	                    		else
	                    			q_box("vcc_vu.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $(this).val() + "';" + t_accy, t_tablea, "95%", "95%", q_getMsg("pop"+t_tablea));
	                    	}else if (q_getPara('sys.project').toUpperCase()=='SF'){
	                    		q_box("vcc_sf.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $(this).val() + "';" + t_accy, t_tablea, "95%", "95%", q_getMsg("pop"+t_tablea));	                    		
	                    	}else if(t_tablea.length>0 && $(this).val().indexOf('TAX')==-1 && !($(this).val().indexOf('-')>-1 && $(this).val().indexOf('/')>-1)){//稅額和月結排除
	                    		//t_tablea = t_tablea + q_getPara('sys.project');
	                    		//q_box(t_tablea+".aspx?;;;noa='" + $(this).val() + "'", t_tablea, "95%", "95%", q_getMsg("pop"+t_tablea));	
	                    		q_box(t_tablea+".aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $(this).val() + "';" + t_accy, t_tablea, "95%", "95%", q_getMsg("pop"+t_tablea));
	                    	}
	                    });
	                    
	                    $('#btnMinut__' + i).click(function() {
							setTimeout(bbtsum,10);
						});
						
						$('#txtMount__'+i).focusout(function() {
							if(q_cur==1 || q_cur==2)
								bbtsum();
						});
						
						$('#txtWeight__'+i).focusout(function() {
							if(q_cur==1 || q_cur==2)
								bbtsum();
						});
						$('#txtMoney__'+i).focusout(function() {
							if(q_cur==1 || q_cur==2)
								bbtsum();
						});
                    }
                }
                _bbtAssign();
                bbtsum();
                if(q_getPara('sys.project').toUpperCase()=='BD'){
                	$('.bbtuno').show();
                }
            }

			function btnIns() {
				curData.copy();
				_btnIns();
				curData.paste();
				$('#btnOk').data('guid',guid());//送簽核用
				//暫時先給預設值
				$('#txtTimea').val('10:00:00');
				
				switch(q_getPara('sys.project').toUpperCase()){
					case 'ES':
						if($('#txtCno').val()=='A'){
							$('#txtProductno_0').val('01');
							$('#txtProduct_0').val('運費');
							$('#txtMount_0').val(1);
						}else if($('#txtCno').val()=='B'){
							$('#txtProductno_0').val('02');
							$('#txtProduct_0').val('搬運工資');
							$('#txtMount_0').val(1);
						}
						break;
					case 'PE':
						$('#txtMon').val('');
						$('#txtCustno').val('');
						$('#txtComp').val('');
						$('#txtZip').val('');
						$('#txtAddress').val('');
						break;
					case 'VU':
						$('#txtCustno').val('');
						$('#txtComp').val('');
						$('#txtSerial').val('');
						$('#txtZip').val('');
						$('#txtAddress').val('');
						$('#txtBuyerno').val('');
						$('#txtBuyer').val('');
						break;
					case 'XY':
						$('#txtMon').val(q_date().substr(0,r_lenm));
						break;
				}
				
				$('#txtNoa').data('key_buyer','');//檢查發票抬頭用
				
				$('#cmbTaxtype').val(1);
				Lock(1, {
					opacity : 0
				});
				q_gt('acomp', '', 0, 0, 0, 'getAcomp', r_accy);
				
				if (q_getPara('sys.project').toUpperCase()=='XY' && window.parent.q_name=='z_umm_xy') {
					if(q_getHref()[1]!='' && q_getHref()[1]!=undefined){
						$('#txtCustno').val(q_getHref()[1]);
						$('#txtCustno').change();
					}
				}
			}
			var guid = (function() {
				function s4() {return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);}
				return function() {return s4() + s4() + '-' + s4() + '-' + s4() + '-' +s4() + '-' + s4() + s4() + s4();};
			})();

			function btnModi() {
				if (emp($('#txtNoa').val()))
					return;
				_btnModi();
				$('#btnOk').data('guid',guid());//送簽核用
				$('#txtNoa').data('key_buyer','');//檢查發票抬頭用
				$('#txtDatea').focus();
				$('#txtNoa').attr('readonly', true).css('color', 'green').css('background-color', 'rgb(237,237,237)');
				//讓發票號碼不可修改
				sum();
			}

			function btnPrint() {
				switch(q_getPara('sys.project').toUpperCase()){
					case 'WH':
						q_box("z_vccap_wh.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + JSON.stringify({noa:trim($('#txtNoa').val())}) + ";" + r_accy + "_" + r_cno, 'vcca', "95%", "95%", q_getMsg("popPrint"));
						break;
					case 'ES':
						q_box("z_vccap_es.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + JSON.stringify({noa:trim($('#txtNoa').val())}) + ";" + r_accy + "_" + r_cno, 'vcca', "95%", "95%", q_getMsg("popPrint"));
						break;
					case 'DC':
						q_box("z_vccadc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + JSON.stringify({noa:trim($('#txtNoa').val())}) + ";" + r_accy + "_" + r_cno, 'vcca', "95%", "95%", q_getMsg("popPrint"));
						break;
					case 'IT':
						q_box('z_vccap_it.aspx' + "?;;;;" + r_accy + ";noa=" + trim($('#txtNoa').val()), '', "95%", "95%", q_getMsg("popPrint"));
						break;
					case 'XY':
						q_box('z_vccp_xy.aspx' + "?;;;noa=" + trim($('#txtNoa').val()) + ";"+ r_accy, '', "95%", "95%", q_getMsg("popPrint"));
						break;
					case 'SH':
						q_box('z_vccap_sh.aspx' + "?;;;noa=" + trim($('#txtNoa').val())+";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
						break;
					case 'PK':
						q_box('z_vccap_pk.aspx' + "?;;;noa=" + trim($('#txtNoa').val())+";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
						break;
					case 'FE':
						q_box('z_vccap_fe.aspx' + "?;;;noa=" + trim($('#txtNoa').val())+";" + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
						break;
					default:
						q_box("z_vccap.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + JSON.stringify({noa:trim($('#txtNoa').val())}) + ";" + r_accy + "_" + r_cno, 'vcca', "95%", "95%", q_getMsg("popPrint"));
						break;	
				}
			}

			function wrServer(key_value) {
				var i;

				$('#txt' + bbmKey[0].substr(0, 1).toUpperCase() + bbmKey[0].substr(1)).val(key_value);
				_btnOk(key_value, bbmKey[0], bbsKey[1], '', 2);
			}

			function bbsSave(as) {/// 表身 寫入資料庫前，寫入需要欄位
				if (!as['productno'] && !as['product']) {//不存檔條件
					as[bbsKey[1]] = '';
					/// no2 為空，不存檔
					return;
				}
				q_nowf();
				as['cno'] = abbm2['cno'];
                as['datea'] = abbm2['datea'];
				
				return true;
			}
			function bbtSave(as) {/// 表身 寫入資料庫前，寫入需要欄位
				if (!as['vccno']) {//不存檔條件
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				return true;
			}
			
			//105/07/18 XY 表身可以改 表頭只開放 統編和買受人
			function sum() {
				if (!(q_cur == 1 || q_cur == 2))
					return;
				if (q_getPara('sys.project').toUpperCase()=='XY') {
					sum_xy();
					return;
				}
				if (!emp($('#txtVccno').val()))	//103/03/07 出貨單轉來發票金額一律不改
					return;
				//數量為0,自動當作1 //106/05/11 不判斷
				/*for(var i=0;i<q_bbsCount;i++){
					if(q_float('txtMount_'+i)==0)
						$('#txtMount_'+i).val(1);
				}*/
					
				$('#txtTax').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
				var t_mounts, t_prices, t_moneys=0, t_mount = 0, t_money = 0, t_tax=0, t_total=0;
				//銷貨客戶
				$('#txtCustno').attr('readonly', false);
				$('#txtComp').attr('readonly', false);
				//統一編號
				$('#txtSerial').attr('readonly', false);
				//產品金額
				$('#txtMoney').attr('readonly', false);
				//帳款月份
				$('#txtMon').attr('readonly', false);
				//營業稅
				$('#txtTax').attr('readonly', false);
				//總計
				$('#txtTotal').attr('readonly', false);
				//買受人
				$('#txtBuyerno').attr('readonly', false);
				$('#txtBuyer').attr('readonly', false);
				for (var k = 0; k < q_bbsCount; k++) {
					$('#txtMount_'+k).attr('readonly', false);
				}
				
				for (var k = 0; k < q_bbsCount; k++) {
					if(!$('#chkAprice_'+k).prop('checked')){
						$('#txtMoney_'+k).val(round(q_mul(q_float('txtMount_'+k),q_float('txtPrice_'+k)),0));
					}
					t_moneys = q_float('txtMoney_' + k);
                    t_money = q_add(t_money,t_moneys);
				}
				
				t_taxrate = parseFloat(q_getPara('sys.taxrate')) / 100;
				$('#txtTaxrate').val(t_taxrate);
				switch ($('#cmbTaxtype').val()) {
					case '1':
						// 應稅
						if($('#chkAtax').prop('checked')){
							t_tax=round(q_float('txtTax'), 0);
							$('#txtTax').css('color', 'black').css('background', 'white').removeAttr('readonly');  
						}else
							t_tax = round(t_money * t_taxrate, 0);
						t_total = t_money + t_tax;
						break;
					case '2':
						//零稅率
						t_tax = 0;
						t_total = t_money + t_tax;
						break;
					case '3':
						// 內含
						t_tax = round(t_money / (1 + t_taxrate) * t_taxrate, 0);
						t_total = t_money;
						t_money = t_total - t_tax;
						break;
					case '4':
						// 免稅
						t_tax = 0;
						t_total = t_money + t_tax;
						break;
					case '5':
						// 自定
						$('#txtTax').css('color', 'black').css('background', 'white').removeAttr('readonly');  
						t_tax = round(q_float('txtTax'), 0);
						t_total = t_money + t_tax;
						if (q_getPara('sys.project').toUpperCase()=='IT') {
							$('#txtMoney').removeAttr('readonly');
							t_money = dec($('#txtMoney').val());
							$('#txtTax').removeAttr('readonly');
							t_tax = round(q_float('txtTax'), 0);
							t_total = t_money + t_tax;
						}
						break;
					case '6':
						// 作廢-清空資料
						t_money = 0, t_tax = 0, t_total = 0;
						/*//銷貨客戶
						$('#txtCustno').val('').attr('readonly', true);
						$('#txtComp').val('').attr('readonly', true);
						//統一編號
						$('#txtSerial').val('').attr('readonly', true);
						//買受人
						$('#txtBuyerno').val('').attr('readonly', true);
						$('#txtBuyer').val('').attr('readonly', true);
						//帳款月份
						$('#txtMon').val('').attr('readonly', true);*/
						//產品金額
						$('#txtMoney').val(0).attr('readonly', true);
						//營業稅
						$('#txtTax').val(0).attr('readonly', true);
						//總計
						$('#txtTotal').val(0).attr('readonly', true);
						for (var k = 0; k < q_bbsCount; k++) {
							$('#txtMount_'+k).val(0).attr('readonly', true);
							$('#txtMoney_'+k).val(0).attr('readonly', true);
						}
						break;
					default:
				}
				$('#txtMoney').val(round(t_money,0));
				$('#txtTax').val(round(t_tax,0));
				$('#txtTotal').val(round(t_total,0));
			}
			
			function sum_xy() {
				//讀取發票聯式
				var t_where = " where=^^ '" + $('#txtNoa').val() + "' between binvono and einvono ^^";
				q_gt('vccar', t_where, 0, 0, 0, 'getcust', r_accy,1);
				var as = _q_appendData("vccar", "", true);
				var tp23='';
				if (as[0] != undefined) {
					tp23=as[0].rev;
				}
				
				if(r_rank>=9 && (q_cur==1 || q_cur==2)){ //105/08/19 開放可修改
					$('#txtVccno').attr('readonly', false);
				}
				
				$('#txtTax').css('color', 'green').css('background', 'RGB(237,237,237)').attr('readonly', 'readonly');
				var t_mounts, t_prices, t_moneys=0, t_mount = 0, t_money = 0, t_tax=0, t_total=0;
				if (!emp($('#txtVccno').val())){
					//統一編號
					$('#txtSerial').attr('readonly', false);
					//買受人
					$('#txtBuyerno').attr('readonly', false);
					$('#txtBuyer').attr('readonly', false);
					if(r_rank<5)
						$('#cmbTaxtype').attr('disabled','disabled');
					$('#txtNoa').attr('disabled','disabled');
					//銷貨客戶
					$('#txtCustno').attr('readonly', true);
					$('#txtComp').attr('readonly', true);
					$('#txtMon').attr('readonly', true);
					//$('#txtDatea').attr('readonly', true);
					$('#txtCno').attr('readonly', true);
					$('#txtAcomp').attr('readonly', true);
					$('#txtZip').attr('readonly', true);
					$('#txtAddress').attr('readonly', true);
					$('#txtMemo').attr('readonly', true);
				}else{
					if(q_cur!=1){
						$('#txtNoa').attr('disabled','disabled');
					}
					//統一編號
					$('#txtSerial').attr('readonly', false);
					//買受人
					$('#txtBuyerno').attr('readonly', false);
					$('#txtBuyer').attr('readonly', false);
					//銷貨客戶
					$('#txtCustno').attr('readonly', false);
					$('#txtComp').attr('readonly', false);
					$('#txtMon').attr('readonly', false);
					$('#txtDatea').attr('readonly', false);
					$('#txtCno').attr('readonly', false);
					$('#txtAcomp').attr('readonly', false);
					$('#txtZip').attr('readonly', false);
					$('#txtAddress').attr('readonly', false);
					$('#txtMemo').attr('readonly', false);
				}
				
				for (var k = 0; k < q_bbsCount; k++) {
					if(!$('#chkAprice_'+k).prop('checked')){
						$('#txtMoney_'+k).val(round(q_mul(q_float('txtMount_'+k),q_float('txtPrice_'+k)),0));
					}
					t_moneys = q_float('txtMoney_' + k);
                    t_money = q_add(t_money,t_moneys);
				}

				t_taxrate = parseFloat(q_getPara('sys.taxrate')) / 100;
				$('#txtTaxrate').val(t_taxrate);
				switch ($('#cmbTaxtype').val()) {
					case '1':
						// 應稅
						if($('#chkAtax').prop('checked')){
							t_tax=round(q_float('txtTax'), 0);
							$('#txtTax').css('color', 'black').css('background', 'white').removeAttr('readonly');  
						}else{
							if(tp23=='2') //二聯式發票
								t_tax = 0;
							else
								t_tax = round(t_money * t_taxrate, 0);
						}
						t_total = t_money + t_tax;
						break;
					case '2':
						//零稅率
						t_tax = 0;
						t_total = t_money + t_tax;
						break;
					case '3':
						// 內含
						t_tax = round(t_money / (1 + t_taxrate) * t_taxrate, 0);
						t_total = t_money;
						t_money = t_total - t_tax;
						break;
					case '4':
						// 免稅
						t_tax = 0;
						t_total = t_money + t_tax;
						break;
					case '5':
						// 自定
						$('#txtTax').css('color', 'black').css('background', 'white').removeAttr('readonly');  
						t_tax = round(q_float('txtTax'), 0);
						t_total = t_money + t_tax;
						break;
					case '6':
						//只清總金額....2017/08/16
						// 作廢-清空資料
						t_money = 0, t_tax = 0, t_total = 0;
						//帳款月份
						$('#txtMon').val('').attr('readonly', true);
						//總計
						$('#txtTotal').val(0).attr('readonly', true);
						break;
					default:
				}
				$('#txtMoney').val(round(t_money,0));
				$('#txtTax').val(round(t_tax,0));
				$('#txtTotal').val(round(t_total,0));
			}

			function refresh(recno) {
				_refresh(recno);
				refreshBbs();
				t_count = 0;
				try{
					for(var i=0;i<q_bbtCount;i++)
						if($('#txtVccno__'+i).val().length>0)
							t_count ++;
				}catch(e){
					
				}
				
				if(t_count>0)
					$("#dbbt").show();
				else
					$("#dbbt").hide();
			}

			var t_first_ins=true,t_first_ins_count=0;
			function readonly(t_para, empty) {
				_readonly(t_para, empty);
				if (!emp($('#txtVccno').val()) && q_getPara('sys.project').toUpperCase()!='XY'){
					$('#txtNoa').attr('disabled','disabled');
					$('#cmbTaxtype').attr('disabled','disabled');
					$('#btnPlus').attr('disabled','disabled');
					
					for (var i = 0; i < q_bbsCount; i++) {
						$('#btnMinus_'+i).attr('disabled','disabled');
						$('#txtProductno_'+i).attr('disabled','disabled');
						$('#btnProductno_'+i).attr('disabled','disabled');
						$('#txtProduct_'+i).attr('disabled','disabled');
						$('#txtUnit_'+i).attr('disabled','disabled');
						$('#txtMount_'+i).attr('disabled','disabled');
						$('#txtPrice_'+i).attr('disabled','disabled');
						$('#txtMoney_'+i).attr('disabled','disabled');
						$('#txtMemo_'+i).attr('disabled','disabled');
					}
				}
				refreshBbs();
				if (q_getPara('sys.project').toUpperCase()=='XY' && window.parent.q_name=='z_umm_xy' && t_first_ins) {
					if(t_first_ins_count!=0){
						t_first_ins=false;
						sleep(100);
						btnIns();
					}else{
						t_first_ins_count++;
					}
				}
			}
			
			function sleep(milliseconds) {
                var start = new Date().getTime();
                for (var i = 0; i < 1e7; i++) {
                    if ((new Date().getTime() - start) > milliseconds) {
                        break;
                    }
                }
            }

			function btnMinus(id) {
				_btnMinus(id);
				sum();
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
			
			function refreshBbs() {
				//作廢時顯示作廢日期和時間
				if($('#cmbTaxtype').val()=='6'){
					$('.cancelInvoice').show();
				}else{
					$('.cancelInvoice').hide();
				}
				
                //金額小計自訂
				for(var i=0;i<q_bbsCount;i++){
					$('#txtMoney_'+i).attr('readonly','readonly');
					if($('#chkAprice_'+i).prop('checked')){
						$('#txtMoney_'+i).css('color','black').css('background-color','white');
						if(q_cur==1 || q_cur==2)
							$('#txtMoney_'+i).removeAttr('readonly');
					}else{
						$('#txtMoney_'+i).css('color','green').css('background-color','rgb(237,237,237)');
					}
				}
            }
			
			function bbtsum() {
            	var tot_mount=0,tot_weight=0,tot_money=0;
                for (var i = 0; i < q_bbtCount; i++) {
	                tot_mount=q_add(tot_mount,dec($('#txtMount__'+i).val()));
	                tot_weight=q_add(tot_weight,dec($('#txtWeight__'+i).val()));
	                tot_money=q_add(tot_money,dec($('#txtMoney__'+i).val()));
				}
				if(tot_mount!=0)
					$('#lblTot_mount').text(FormatNumber(tot_mount));
				else
					$('#lblTot_mount').text('');
				if(tot_weight!=0)
					$('#lblTot_weight').text(FormatNumber(tot_weight));
				else
					$('#lblTot_weight').text('');
				if(tot_money!=0)
					$('#lblTot_money').text(FormatNumber(tot_money));
				else
					$('#lblTot_money').text('');
            }
            
            function cust_buyer(){
            	//買受人改 cust_buyer_b
				aPop = new Array(['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx']
				, ['txtAddress', '', 'view_road', 'memo,zipcode', '0txtAddress,txtZip', 'road_b.aspx']
				, ['txtCustno', 'lblCust', 'cust', 'noa,comp,nick,serial,zip_invo,addr_invo', 'txtCustno,txtComp,txtNick,txtSerial,txtZip,txtAddress', 'cust_b.aspx']
				, ['txtBuyerno', '', 'cust', 'noa,comp,serial', '0txtBuyerno,txtBuyer,txtSerial,txtMemo', 'cust_b.aspx']
				, ['txtSerial', 'lblSerial', 'vccabuyer', 'serial,noa,buyer', '0txtSerial,txtBuyerno,txtBuyer', 'vccabuyer_b.aspx']
				, ['txtProductno_', 'btnProductno_', 'ucca', 'noa,product,unit', 'txtProductno_,txtProduct_,txtUnit_', 'ucca_b.aspx']);
				
				$('#lblBuyer').click(function(e){
					if(!(q_cur==1 || q_cur==2))
						return;
					b_pop = '';
					var t_custno = $('#txtCustno').val();
                	var t_cno = $('#txtCno').val();
                	var t_condition = '';
                	var t_where ='';
                	if(t_custno.length>0)
                		q_box("cust_buyer_b.aspx?" + r_userno + ";" + r_name + ";" + q_getId()[2] + ";" + t_where+";"+";"+JSON.stringify({custno:t_custno,cno:t_cno,condition:t_condition,q_time:q_time}), "cust_buyer", "95%", "95%", '**');
					else{
						q_msg($('#txtCustno'),'輸入客戶編號，以便顯示買受人記錄。');
					}
				});
            }
            
            function FormatNumber(n) {
				var xx = "";
				if (n < 0) {
					n = Math.abs(n);
					xx = "-";
				}
				n += "";
				var arr = n.split(".");
				var re = /(\d{1,3})(?=(\d{3})+$)/g;
				return xx + arr[0].replace(re, "$1,") + (arr.length == 2 ? "." + arr[1] : "");
			}
		</script>
		<style type="text/css">
            #dmain {
                overflow: visible;
            }
            .dview {
                float: left;
                width: 1000px;
                border-width: 0px;
            }
            .tview {
                border: 5px solid gray;
                font-size: medium;
                background-color: black;
            }
            .tview tr {
                height: 100%;
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
                width: 1000px;
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
                width: 16%;
            }
            .tbbm .tdZ {
                width: 1%;
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
                font-size: medium;
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
            input[type="text"], input[type="button"] {
                font-size: medium;
            }
            .dbbs {
                width: 1200px;
            }
            .dbbs .tbbs {
                margin: 0;
                padding: 2px;
                border: 2px lightgrey double;
                border-spacing: 1;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                /*background: #cad3ff;*/
                background: lightgrey;
                width: 100%;
            }
            .dbbs .tbbs tr {
                height: 35px;
            }
            .dbbs .tbbs tr td {
                text-align: center;
                border: 2px lightgrey double;
            }
            .dbbs .tbbs select {
                border-width: 1px;
                padding: 0px;
                margin: -1px;
                font-size: medium;
            }
            #dbbt {
                width: 1260px;
            }
            #tbbt {
                margin: 0;
                padding: 2px;
                border: 2px pink double;
                border-spacing: 1;
                border-collapse: collapse;
                font-size: medium;
                color: blue;
                background: pink;
                width: 100%;
            }
            #tbbt tr {
                height: 35px;
            }
            #tbbt tr td {
                text-align: center;
                border: 2px pink double;
            }

		</style>
	</head>
	<body ondragstart="return false" draggable="false"
	ondragenter="event.dataTransfer.dropEffect='none'; event.stopPropagation(); event.preventDefault();"
	ondragover="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	ondrop="event.dataTransfer.dropEffect='none';event.stopPropagation(); event.preventDefault();"
	>
		<!--#include file="../inc/toolbar.inc"-->
		<div id="dmain">
			<div class="dview" id="dview">
				<table class="tview" id="tview">
					<tr>
						<td align="center" style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td align="center" style="width:120px; color:black;"><a id='vewNoa'> </a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewDatea'> </a></td>
                        <td align="center" style="width:80px; color:black;"><a id='vewCust'> </a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewBuyer'> </a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewSerial'>統編</a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewMoney'> </a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewTax'> </a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewTotal'> </a></td>
						<td align="center" style="width:200px; color:black;"><a id='vewMemo'> </a></td>
						<td class='isVU2' align="center" style="width:200px; color:black;"><a id='vewAccno'>傳票號碼</a></td>
					</tr>
					<tr>
						<td>
						<input id="chkBrow.*" type="checkbox" style=' '/>
						</td>
						<td id='noa' style="text-align: center;">~noa</td>
						<td id='datea' style="text-align: center;">~datea</td>
                        <td id='nick' style="text-align: left;">~nick</td>
						<td id='buyer,4' style="text-align: left;">~buyer,4</td>
						<td id='serial' style="text-align: left;">~serial</td>
						<td id='money,0,1' style="text-align: right;">~money,0,1</td>
						<td id='tax,0,1' style="text-align: right;">~tax,0,1</td>
						<td id='total,0,1' style="text-align: right;">~total,0,1</td>
						<td id='memo' style="text-align: left;">~memo</td>
						<td class='isVU2' id='accno' style="text-align: left;">~accno</td>
					</tr>
				</table>
			</div>
			<div class="dbbm">
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
						<td>
							<input id="txtDatea"  type="text" class="txt c1"/>
							<!-- timea  B2C用 -->
							<input id="txtTimea"  type="text" style="display:none;"/>
						</td>
						<td><span> </span><a id="lblAcomp" class="lbl btn"> </a></td>
						<td colspan="3">
							<input id="txtCno" type="text" style="float:left; width:25%;">
							<input id="txtAcomp" type="text" style="float:left; width:75%;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td><input id="txtNoa"  type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblMon' class="lbl"> </a></td>
						<td><input id="txtMon"  type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblChkno' class="lbl"> </a></td>
						<td><input id="txtChkno"  type="text" class="txt c1" /></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblCust" class="lbl btn"> </a></td>
						<td colspan="3">
							<input id="txtCustno" type="text" style="float:left; width:30%;">
							<input id="txtComp" type="text" style="float:left; width:70%;"/>
							<input id="txtNick" type="text"  style="display:none;"/>
						</td>
						<td><span> </span><a id='lblSerial' class="lbl"> </a></td>
						<td><input id="txtSerial" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblAddress' class="lbl"> </a></td>
						<td colspan="5">
							<input id="txtZip" type="text" style="float:left; width:10%;"/>
							<input id="txtAddress" type="text" style="float:left; width:90%;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblTaxtype' class="lbl"> </a></td>
						<td><select id="cmbTaxtype" class="txt c1" > </select></td>
						<td><span> </span><a id='lblBuyer' class="lbl btn"> </a></td>
						<td colspan="3">
							<input id="txtBuyerno"  type="text"  style="float:left; width:30%;"/>
							<input id="txtBuyer" type="text"  style="float:left; width:70%;"/>
						</td>
					</tr>
					<tr class="cancelInvoice" style="display:none;">
						<td><span> </span><a id='lblCanceldate' class="lbl">作廢日期</a></td>
						<td><input id="txtCanceldate" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblCanceltime' class="lbl">作廢時間</a></td>
						<td><input id="txtCanceltime" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblRtdn' class="lbl">專案作廢核准文號</a></td>
						<td><input id="txtRtdn" type="text" class="txt c1" title="若發票的作廢時間超過申報期間，則此欄位為必填欄位。"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblMoney' class="lbl"> </a></td>
						<td><input id="txtMoney"  type="text"  class="txt num c1"/></td>
						<td><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td>
							<input id="txtTax"  type="text"  class="txt num c1" style="width: 90%;"/>
							<input id="chkAtax" type="checkbox" onchange='sum()' style="display: none;" />
							<input id="txtTaxrate"  type="text" style="display:none;"/>
						</td>
						<td><span> </span><a id='lblTotal' class="lbl"> </a></td>
						<td><input id="txtTotal"  type="text"  class="txt num c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl" > </a></td>
						<td colspan='5'><textarea id="txtMemo" rows="3" class="txt c1" style="height: 50px;" > </textarea></td>
					</tr>
					<tr class="isST2" style="display: none;">
						<td> </td>
						<td colspan='4'><input id="txtProduct" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td><input id="txtWorker"  type="text"  class="txt c1"/></td>
						<td><span> </span><a id='lblAccno' class="lbl btn"> </a></td>
						<td><input id="txtAccno"  type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblVccno' class="lbl btn"> </a></td>
						<td><input id="txtVccno"  type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl" id="lblCcm">通關方式註記</a></td>
						<td><select id="cmbCcm" class="txt c1" title="若為零稅率發票，此為必填欄位(CustomsClearanceMark)"> </select></td>
						<td><span> </span><a class="lbl">列印註記</a></td>
						<td><select id="cmbPrintmark" class="txt c1"> </select></td>
						<td><span> </span><a class="lbl">隨機碼</a></td>
						<td><input type="text" id="txtRandnumber" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a class="lbl">載具類別號碼</a></td>
						<td><input type="text" id="txtCarriertype" class="txt c1" list="listCarriertype"/></td>
						<td><span> </span><a class="lbl">載具顯碼</a></td>
						<td><input type="text" id="txtCarrierid1" class="txt c1"/></td>
						<td><span> </span><a class="lbl">載具隱碼</a></td>
						<td><input type="text" id="txtCarrierid2" class="txt c1"/></td>
					</tr>
					<tr>
						<td> </td>
						<td><input type="checkbox" style="float:left;" id="chkDonatemark"/><span style="display:block;width:100px;float:left;">捐贈發票</span></td>
						<td><span> </span><a class="lbl">捐贈對象(愛心碼)</a></td>
						<td><input type="text" id="txtNpoban" class="txt c1"/></td>
					</tr>
					<tr>
						<td> </td>
						<td><input type="checkbox" style="float:left;" id="chkIssend"/><span style="display:block;width:100px;float:left;">開立</span></td>
						<td><input type="checkbox" style="float:left;" id="chkIssendconfirm"/><span style="display:block;width:100px;float:left;">開立接收確認</span></td>
						<td><input type="checkbox" style="float:left;" id="chkIscancel"/><span style="display:block;width:100px;float:left;">作廢</span></td>
						<td><input type="checkbox" style="float:left;" id="chkIscancelconfirm"/><span style="display:block;width:100px;float:left;">作廢接收確認</span></td>
						
					</tr>
					<tr>
						<td><input type="checkbox" style="float:left;" id="chkIsvoid"/>
							<span style="display:block;width:70px;float:left;">註銷</span>
							<span> </span><a id='lblVoiddate' class="lbl">註銷日期</a>
						</td>	
						<td><input id="txtVoiddate" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblVoidtime' class="lbl">註銷時間</a></td>
						<td><input id="txtVoidtime" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblVoidreason' class="lbl">註銷原因</a></td>
						<td><input id="txtVoidreason" type="text" class="txt c1"/></td>
					</tr>
					<tr style="display:none;">
						<td> </td>
						<td> </td>
						<td> </td>
						<td> </td>
						<td><span> </span><a id='lblTrdno' class="lbl btn"> </a></td>
						<td><input id="txtTrdno"  type="text" class="txt c1"/></td>
					</tr>
				</table>
			</div>
		</div>
		<datalist id="listCarriertype"> 
			<option value="3J0002">手機條碼</option>
			<option value="CQ0001">自然人憑證條碼</option>
		</datalist>
		<input class="einvoice" type="button" id="btnA0101" title="A0101" value="開立發票" style="width:200px;height:50px;white-space:normal;display:none;"/>
		<span style="display:block;,width:5px;height:5px;"> </span>
		<input class="einvoice" type="button" id="btnA0201" title="A0201" value="作廢發票" style="width:200px;height:50px;white-space:normal;display:none;"/>
		<span style="display:block;,width:200px;height:30px;"> </span>
		<input class="einvoice" type="button" id="btnVccb" value="折讓／退回" style="width:200px;height:50px;white-space:normal;display:none;"/>
		<span style="display:block;,width:5px;height:30px;"> </span>
		<input class="einvoice" type="button" id="btnA0401" title="A0401" value="開立發票存證" style="width:200px;height:50px;white-space:normal;display:none;"/>
		<span style="display:block;,width:5px;height:5px;"> </span>
		<input class="einvoice" type="button" id="btnA0501" title="A0501" value="作廢發票存證" style="width:200px;height:50px;white-space:normal;display:none;"/>
		<span style="display:block;,width:200px;height:30px;"> </span>
		<input class="einvoice" type="button" id="btnC0401" title="C0401" value="(B2C)開立發票存證" style="width:200px;height:50px;white-space:normal;display:none;"/>
		<span style="display:block;,width:5px;height:5px;"> </span>
		<input class="einvoice" type="button" id="btnC0501" title="C0501" value="(B2C)作廢發票存證" style="width:200px;height:50px;white-space:normal;display:none;"/>
		<span style="display:block;,width:5px;height:5px;"> </span>
		<input class="einvoice" type="button" id="btnC0701" title="C0701" value="(B2C)註銷發票存證" style="width:200px;height:50px;white-space:normal;display:none;"/>
		<div class='dbbs'>
			<table id="tbbs" class='tbbs' style=' text-align:center'>
				<tr style='color:white; background:#003366;' >
					<td  align="center" style="width:30px;">
						<input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  />
					</td>
					<td align="center" style="width:20px;"> </td>
					<td align="center" style="width:80px;"><a id='lblProductno'> </a></td>
					<td align="center" style="width:200px;"><a id='lblProduct'> </a></td>
					<td align="center" style="width:20px;"><a id='lblUnit'> </a></td>
					<td align="center" style="width:70px;"><a id='lblMount'> </a></td>
					<td align="center" style="width:70px;"><a id='lblPrice'> </a></td>
					<td align="center" style="width:80px;"><a id='lblTotals'> </a></td>
					<td align="center" style="width:80px;"><a id='lblAprice'>自訂金額</a></td>
					<td align="center" style="width:80px;display: none;" class="ordeno"><a id='lblOrdeno'> </a></td>
					<td align="center" style="width:180px;"><a id='lblMemos'> </a></td>
				</tr>
				<tr id="tr.*" class='data' style='background:#cad3ff;'>
					<td align="center">
						<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
						<input id="txtNoq.*" type="text" style="display: none;" />
					</td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td>
						<input id="txtProductno.*" type="text" style="float:left;width: 80%;"/>
						<input id="btnProductno.*" type="button" value=".." style="float:left;width: 15%;"/>
					</td>
					<td><input id="txtProduct.*" type="text" style="float:left;width: 95%;"/></td>
					<td><input id="txtUnit.*" type="text" style="float:left;width: 95%;"/></td>
					<td><input id="txtMount.*" type="text" style="float:left;width: 95%; text-align: right;"/></td>
					<td><input id="txtPrice.*" type="text" style="float:left;width: 95%; text-align: right;"/></td>
					<td><input id="txtMoney.*" type="text" style="float:left;width: 95%; text-align: right;"/></td>
					<td><input id="chkAprice.*" type="checkbox"/></td>
					<td class="ordeno" style="display: none;"><input id="txtOrdeno.*" type="text" style="float:left;width: 95%;"/></td>
					<td><input id="txtMemo.*" type="text" style="float:left;width: 95%;"/></td>
				</tr>
			</table>
		</div>
		<input id="q_sys" type="hidden" />
		<div id="dbbt" style="display:none;">
			<table id="tbbt">
				<tbody>
					<tr class="head" style="color:white; background:#003366;">
						<td style="width:20px;">
						<input id="btnPlut" type="button" style="font-size: medium; font-weight: bold;" value="＋"/>
						</td>
						<td style="width:20px;"> </td>
						<td style="width:120px; text-align: center;">出貨單號</td>
						<td style="width:150px; text-align: center;display: none;" class="bbtuno">批號</td>
						<td style="width:100px; text-align: center;display: none;">品號</td>
						<td style="width:200px; text-align: center;">品名</td>
						<td style="width:100px; text-align: center;">數量<BR><a id='lblTot_mount'> </a></td>
						<td style="width:100px; text-align: center;">重量<BR><a id='lblTot_weight'> </a></td>
						<td style="width:100px; text-align: center;">單價</td>
						<td style="width:100px; text-align: center;">金額<BR><a id='lblTot_money'> </a></td>
					</tr>
					<tr>
						<td>
							<input id="btnMinut..*"  type="button" style="font-size: medium; font-weight: bold;" value="－"/>
							<input class="txt" id="txtNoq..*" type="text" style="display: none;"/>
						</td>
						<td><a id="lblNo..*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
						<td>
							<input class="txt" id="txtVccaccy..*" type="text" style="width:95%;display:none;"/>
							<input class="txt" id="txtTablea..*" type="hidden"/>
							<input class="txt" id="txtVccno..*" type="text" style="width:75%;float:left;"/>
							<input class="txt" id="txtVccnoq..*" type="text" style="width:15%;float:left;"/>
						</td>
						<td style="display: none;" class="bbtuno"><input class="txt" id="txtUno..*" type="text" style="width:95%;float:left;"/></td>
						<td style="display: none;"><input class="txt" id="txtProductno..*" type="text" style="width:95%;float:left;"/></td>
						<td><input class="txt" id="txtProduct..*" type="text" style="width:95%;float:left;"/></td>
						<td><input class="txt" id="txtMount..*" type="text" style="width:95%;text-align: right;"/></td>
						<td><input class="txt" id="txtWeight..*" type="text" style="width:95%;text-align: right;"/></td>
						<td><input class="txt" id="txtPrice..*" type="text" style="width:95%;text-align: right;"/></td>
						<td><input class="txt" id="txtMoney..*" type="text" style="width:95%;text-align: right;"/></td>
					</tr>
				</tbody>
			</table>
		</div>
	</body>
</html>