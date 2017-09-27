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
			//1030929 進貨發票沒有買受人>>拿掉
            this.errorHandler = null;
            function onPageError(error) {
                alert("An error occurred:\r\n" + error.Message);
            }

            q_tables = 't';
            var q_name = "rc2a";
            var decbbs = ['mount', 'price', 'money', 'tax'];
            var decbbm = ['total', 'money', 'tax'];
            var q_readonly = ['txtMoney', 'txtTotal', 'txtTax', 'txtWorker', 'txtAccno','txtProduct'
            	,'chkIssend','chkIssendconfirm','chkIscancel','chkIscancelconfirm'];
            var q_readonlys = [];
            var q_readonlyt = ['txtRc2accy','txtRc2no','txtRc2noq','txtUno'];
            var bbmNum = [['txtMoney', 15, 0], ['txtTax', 15, 0], ['txtTotal', 15, 0]];
            var bbsNum = [['txtMount', 15, 3], ['txtPrice', 15, 3], ['txtMoney', 15, 0]];
            var bbtNum = [['txtMount', 15, 0, 1],['txtWeight', 15, 2, 1],['txtPrice', 15, 2, 1],['txtMoney', 15, 0, 1]];
            var bbmMask = [];
            var bbsMask = [];
            var bbtMask = [];
            q_sqlCount = 6;
            brwCount = 6;
            brwList = [];
            brwNowPage = 0;
            brwKey = 'Datea';
            aPop = new Array(['txtTggno', 'lblTgg', 'tgg', 'noa,comp,serial,addr_invo', 'txtTggno,txtComp,txtSerial,txtAddress', 'tgg_b.aspx']
            , ['txtAddress', '', 'view_road', 'memo,zipcode', '0txtAddress', 'road_b.aspx']
            , ['txtCno', 'lblAcomp', 'acomp', 'noa,acomp', 'txtCno,txtAcomp', 'acomp_b.aspx']
            //, ['txtBuyerno', 'lblBuyer', 'cust', 'noa,comp', 'txtBuyerno,txtBuyer', 'cust_b.aspx']
            , ['txtProductno_', 'btnProductno_', 'ucca', 'noa,product,unit', 'txtProductno_,txtProduct_,txtUnit_', 'ucca_b.aspx']
            ,['txtAcc1_', 'btnAcc_', 'acc', 'acc1,acc2', 'txtAcc1_,txtAcc2_', "acc_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + "; ;" + r_accy + '_' + r_cno]
            );

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
            }
            
			function sum() {
                if (!(q_cur == 1 || q_cur == 2))
                    return;
                $('#txtTax').attr('readonly', 'readonly');
                var t_moneys=0, t_money = 0, t_taxrate, t_tax, t_total;

                for (var k = 0; k < q_bbsCount; k++) {
                    t_moneys = q_float('txtMoney_' + k);
                    t_money = q_add(t_money,t_moneys);
                }
                
                t_taxrate = q_float('txtTaxrate'); 
                switch ($('#cmbTaxtype').val()) {
                    case '1':
                        // 應稅
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
                        $('#txtTax').removeAttr('readonly');
                        t_tax = round(q_float('txtTax'), 0);
                        t_total = t_money + t_tax;
                         if(q_getPara('sys.comp').indexOf('英特瑞')>-1 || q_getPara('sys.comp').indexOf('安美得')>-1){
                        	$('#txtMoney').removeAttr('readonly');
                        	t_money=dec($('#txtMoney').val());
                        	 $('#txtTax').removeAttr('readonly');
	                        t_tax = round(q_float('txtTax'), 0);
	                        t_total = t_money + t_tax;
                        }
                        break;
                    case '6':
                        // 作廢-清空資料
                        t_money = 0,t_tax = 0, t_total = 0;
                        /*//銷貨客戶
                        $('#txtTggno').val('');
                        $('#txtTggno').attr('readonly', true);
                        $('#txtComp').val('');
                        $('#txtComp').attr('readonly', true);
                        //統一編號
                        $('#txtSerial').val('');
                        $('#txtSerial').attr('readonly', true);
                        
                        //帳款月份
                        $('#txtMon').val('');
                        $('#txtMon').attr('readonly', true);
                        
                        //檢查號碼
                        $('#txtChkno').val('');
                        $('#txtChkno').attr('readonly', true);
                        //轉會計傳票編號
                        $('#txtAccno').val('');
                        $('#txtAccno').attr('readonly', true);
                        //買受人
                        //$('#txtBuyerno').val('');
                        //$('#txtBuyerno').attr('readonly', true);
                        //$('#txtBuyer').val('');
                        //$('#txtBuyer').attr('readonly', true);
                        //發票備註
                        $('#txtMemo').val('');*/
                        
                        //產品金額
                        $('#txtMoney').val(0);
                        $('#txtMoney').attr('readonly', true);
                        //營業稅
                        $('#txtTax').val(0);
                        $('#txtTax').attr('readonly', true);
                        //總計
                        $('#txtTotal').val(0);
                        $('#txtTotal').attr('readonly', true);
                        break;
                    default:
                }
                $('#txtMoney').val(t_money);
                $('#txtTax').val(t_tax);
                $('#txtTotal').val(t_total);
            }
            
            function mainPost() {
                q_getFormat();
                bbmMask = [['txtCanceldate', r_picd],['txtCanceltime', '99:99:99'],['txtDatea', r_picd], ['txtMon', r_picm]];
                q_mask(bbmMask);
//*********************************************************************************************
				switch(q_getPara('sys.project').toUpperCase()){
					case 'RS':
						$('.einvoice').show();
						break;
				}
				$('#btnA0202').click(function(e){
					if(q_xchg!=2){
						$('#btnXchg').click();
					}
					if(!$('#chkIscancel').prop('checked')){
						alert('錯誤:發票尚未作廢。');
						return;
					}
					if($('#chkIscancelconfirm').prop('checked')){
						alert('錯誤:發票已作廢確認。');
						return;
					}
					var t_invoiceNumber = $.trim($('#txtNoa').val());
					if(t_invoiceNumber.length==0){
						alert('錯誤:無單號');
						return;
					}
					if (!confirm("傳送發票作廢確認?")) {
					    return;
					}
					$.ajax({
						invoiceNumber : t_invoiceNumber,
	                    url: "../einvoice/A0202g.aspx?invoice="+t_invoiceNumber,
	                    type: 'POST',
	                    data: '',
	                    dataType: 'text',
	                    //timeout: 10000,
	                    success: function(data){
	                    	tmp = JSON.parse(data);
	                    		if(tmp.status!='OK'){
	                    			alert(tmp.msg);	                    		
	                    		}else if(this.invoiceNumber==$.trim($('#txtNoa').val())){
	                    			$('#chkIscancelconfirm').prop('checked',true);
	                    			alert(this.invoiceNumber+" 確認完成。");	
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
					t_rc2a = {
						table:'RC2A',
						noa:$.trim($('#txtNoa').val()),
						datea:$.trim($('#txtDatea').val()),
						cno:$.trim($('#txtCno').val()),
						acomp:$.trim($('#txtAcomp').val()),
						serial:$.trim($('#txtSerial').val()),
						tggno:$.trim($('#txtTggno').val()),
						comp:$.trim($('#txtComp').val()),
						address:$.trim($('#txtAddress').val()),
						taxtype:$.trim($('#cmbTaxtype').val()),
						taxrate:q_float('txtTaxrate'),
						money:q_float('txtMoney'),
						tax:q_float('txtTax'),
						total:q_float('txtTotal'),
						bbs:[]
					};
					for(var i=0;i<q_bbsCount;i++){
						t_rc2a.bbs.push({
							productno:$.trim($('#txtProductno_'+i).val()),
							product:$.trim($('#txtProduct_'+i).val()),
							unit:$.trim($('#txtUnit_'+i).val()),
							mount:q_float('txtMount_'+i),
							price:q_float('txtPrice_'+i),
							money:q_float('txtMoney_'+i),
						});
					}
					t_where = " exists(select noa from vccbs where vccbs.noa=vccb.noa and charindex('" + t_rc2a.noa + "',vccbs.invono)>0)";
					q_box("vccb.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where+";"+";"+JSON.stringify({data:t_rc2a}), "vccb", "95%", "95%", '');
				});
				$('#btnA0102').click(function(e){
					if(q_xchg!=2){
						$('#btnXchg').click();
					}
					if(!$('#chkIssend').prop('checked')){
						alert('錯誤:不是接收的發票。');
						return;
					}
					if($('#chkIssendconfirm').prop('checked')){
						alert('錯誤:已確認發票。');
						return;
					}
					if($('#chkIscancel').prop('checked')){
						alert('錯誤:發票已作廢。');
						return;
					}
					if($('#chkIscancelconfirm').prop('checked')){
						alert('錯誤:發票已作廢確認。');
						return;
					}
					var t_invoiceNumber = $.trim($('#txtNoa').val());
					if(t_invoiceNumber.length==0){
						alert('錯誤:無單號');
						return;
					}
					if (!confirm("傳送發票確認?")) {
					    return;
					}
					$.ajax({
						invoiceNumber : t_invoiceNumber,
	                    url: "../einvoice/A0102g.aspx?invoice="+t_invoiceNumber,
	                    type: 'POST',
	                    data: '',
	                    dataType: 'text',
	                    //timeout: 10000,
	                    success: function(data){
	                    	tmp = JSON.parse(data);
	                    		if(tmp.status!='OK'){
	                    			alert(tmp.msg);	                    		
	                    		}else if(this.invoiceNumber==$.trim($('#txtNoa').val())){
	                    			$('#chkIssendconfirm').prop('checked',true);
	                    			alert(tmp.invoiceConfirm[0].InvoiceNumber+" 傳送發票確認。");	
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
				
                
                if(q_getPara('sys.project')=='sh')
                	q_cmbParse("cmbTaxtype",q_getPara('sys.taxtype'));
                else 
                	q_cmbParse("cmbTaxtype",q_getPara('vcca.taxtype'));
                
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
                });
                $('#txtTax').change(function() {
                    sum();
                });
                $('#txtMoney').change(function() {
                    sum();
                });
                $('#txtTaxrate').change(function() {
                    sum();
                });
                $('#lblAccno').click(function() {
                	var t_years=0;
					if(q_getPara('sys.project').toUpperCase().substring(0,2)=='VU' && r_len=='4'){
						t_years=$('#txtDatea').val().substring(0, 4)-1911;
					}else{
						t_years=$('#txtDatea').val().substring(0, 3);
					}
                    q_pop('txtAccno', "accc.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";accc3='" + $('#txtAccno').val() + "';" + t_years + '_' + r_cno, 'accc', 'accc3', 'accc2', "92%", "1054px", q_getMsg('popAccc'), true);
                });
                
                if(q_getPara('sys.project').toUpperCase()=='BD'){
                	$('#btnRc2').show();
                	$('#dbbt').show();
                }else{
                	$('#btnRc2').hide();
                	$('#dbbt').hide();
                }
                
                $('#btnRc2').click(function() {
                	if(q_cur==1 || q_cur==2){
						var t_tggno = $('#txtTggno').val();
						var t_date = $('#txtDatea').val();
						var t_rc2ano=$('#txtNoa').val();;
						
						t_where = "b.typea!='2' and b.tggno='"+t_tggno+"' and (c.noa='"+t_rc2ano+"' or c.noa is null) ";
						t_where +="and b.datea<='"+t_date+"'";
						q_box("rc2arc2_b.aspx?" + r_userno + ";" + r_name + ";" + q_time + ";" + t_where+";"+";"+JSON.stringify({rc2ano:t_rc2ano,tggno:t_tggno}), "rc2arc2", "95%", "95%", '');
						
					}
                });
            }

            function q_boxClose(s2) {///   q_boxClose 2/4
                var ret;
                switch (b_pop) {
                	case 'rc2arc2':
                        if (b_ret != null) {
                        	as = b_ret;
                        	for(var i=0;i<q_bbtCount;i++){
                        		$('#btnMinut__'+i).click();
                        	}
                        	
                        	for(var i=0;i<as.length;i++){
								if(as[i].tablea==undefined){
									as[i].tablea='rc2st';
								}
                        	}
                        	
                    		q_gridAddRow(bbtHtm, 'tbbt', 'txtTablea,txtRc2accy,txtRc2no,txtRc2noq,txtUno,txtProductno,txtProduct,txtMount,txtWeight,txtPrice,txtMoney'
                        	, as.length, as, 'tablea,accy,noa,noq,uno,productno,product,mount,weight,price,total', '','');
                        }else{
                        	Unlock(1);
                        }
                        break;
                    case q_name + '_s':
                        q_boxClose2(s2);
                        break;
                }/// end Switch
                b_pop = '';
            }

            function q_gtPost(t_name) {
                switch (t_name) {
                    case 'getAcomp':
                        var as = _q_appendData("acomp", "", true);
                        if (as[0] != undefined) {
                            $('#txtCno').val(as[0].noa);
                            $('#txtAcomp').val(as[0].nick);
                        }
                        Unlock(1);
                        $('#txtDatea').val(q_date());
                        $('#txtDatea').focus();
                        $('#cmbTaxtype').val(1);
                        $('#txtTaxrate').val(parseFloat(q_getPara('sys.taxrate')) / 100);
                        break;
                    case 'checkRc2aNoa':
                        var as = _q_appendData("rc2a", "", true);
                        if (as[0] != undefined) {
                            alert('發票號碼已存在。');
                            Unlock(1);
                        } else {
                            wrServer($('#txtNoa').val());
                        }
                    case q_name:
                        if (q_cur == 4)
                            q_Seek_gtPost();
                        break;
                }  /// end switch
            }

            function q_stPost() {
                if (!(q_cur == 1 || q_cur == 2))
                    return false;
				abbm[q_recno]['accno'] = xmlString;
                Unlock(1);
            }

            function btnOk() {
                Lock(1, {
                    opacity : 0
                });
                
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
                
                if (!(/^[a-z,A-Z]{2}[0-9]{8}$/g).test($('#txtNoa').val())) {
                    alert(q_getMsg('lblNoa') + '錯誤。');
                    Unlock(1);
                    return;
                }
                
                if ($.trim($('#txtMon').val()).length == 0)
                	if(r_lenm=='7'){
                		$('#txtMon').val($('#txtDatea').val().substring(0, 7));
                	}else{
                		$('#txtMon').val($('#txtDatea').val().substring(0, 6));
                	}
                    
                    
                $('#txtMon').val($.trim($('#txtMon').val()));
                
                if(r_lenm=='7'){
	                if (!(/^[0-9]{4}\/(?:0?[1-9]|1[0-2])$/g).test($('#txtMon').val())) {
	                    alert(q_getMsg('lblMon') + '錯誤。');
	                    Unlock(1);
	                    return;
	                }
                }else{
                	if (!(/^[0-9]{3}\/(?:0?[1-9]|1[0-2])$/g).test($('#txtMon').val())) {
	                    alert(q_getMsg('lblMon') + '錯誤。');
	                    Unlock(1);
	                    return;
	                }
                }
                
                $('#txtWorker').val(r_name);
                sum();
                if(q_cur==1)
                	q_gt('rc2a', "where=^^ noa='" + $.trim($('#txtNoa').val()) + "'^^", 0, 0, 0, 'checkRc2aNoa', r_accy);
            	else
            		wrServer($('#txtNoa').val());
            }

            function _btnSeek() {
                if (q_cur > 0 && q_cur < 4)// 1-3
                    return;
                q_box('rc2a_s.aspx', q_name + '_s', "500px", "400px", q_getMsg("popSeek"));
            }

            function bbsAssign() {
                for (var j = 0; j < q_bbsCount; j++) {
                    $('#lblNo_' + j).text(j + 1);
                    if (!$('#btnMinus_' + j).hasClass('isAssign')) {
                        $('#txtMount_' + j).change(function() {
                        	t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
                        	$('#txtMoney_'+b_seq).val(round(q_mul(q_float('txtMount_'+b_seq),q_float('txtPrice_'+b_seq)),0));
                            sum();
                        });
                        $('#txtPrice_' + j).change(function() {
                        	t_IdSeq = -1;
							q_bodyId($(this).attr('id'));
							b_seq = t_IdSeq;
                        	$('#txtMoney_'+b_seq).val(round(q_mul(q_float('txtMount_'+b_seq),q_float('txtPrice_'+b_seq)),0));
                            sum();
                        });
                        $('#txtMoney_' + j).change(function() {
                            sum();
                        });
                        
                        $('#txtAcc1_' + j).bind('contextmenu', function(e) {
	                        /*滑鼠右鍵*/
	                        e.preventDefault();
	                        var n = $(this).attr('id').replace('txtAcc1_', '');
	                        $('#btnAcc_'+n).click();
	                    }).change(function() {
	                        var patt = /^(\d{4})([^\.,.]*)$/g;
		                    $(this).val($(this).val().replace(patt,"$1.$2"));
	                        sum();
	                    });
                    }
                }
                _bbsAssign();
                if (q_getPara('sys.project').toUpperCase()!='SH'){
                	$('.acc').hide();
                }
            }
            
            function bbtAssign() {
                for (var i = 0; i < q_bbtCount; i++) {
                    $('#lblNo__' + i).text(i + 1);
                    if (!$('#btnMinut__' + i).hasClass('isAssign')) {
                    	$('#txtRc2no__'+i).bind('contextmenu',function(e) {
	                    	/*滑鼠右鍵*/
	                    	e.preventDefault();
	                    	var n = $(this).attr('id').replace('txtRc2no__','');
	                    	var t_accy = $('#txtRc2accy__'+n).val();
	                    	var t_tablea = emp($('#txtTablea__'+n).val())?'vccst':$('#txtTablea__'+n).val();
	                    	
	                    	if(t_tablea.length>0 && $(this).val().indexOf('TAX')==-1 && !($(this).val().indexOf('-')>-1 && $(this).val().indexOf('/')>-1)){//稅額和月結排除
	                    		q_box(t_tablea+".aspx?" + r_userno + ";" + r_name + ";" + q_time + ";noa='" + $(this).val() + "';" + t_accy, t_tablea, "95%", "95%", q_getMsg("pop"+t_tablea));
	                    	}
	                    });
                    }
                }
                _bbtAssign();
            }

            function btnIns() {
                _btnIns();
                Lock(1, {
                    opacity : 0
                });
                q_gt('acomp', '', 0, 0, 0, 'getAcomp', r_accy);
            }

            function btnModi() {
                if (emp($('#txtNoa').val()))
                    return;
                _btnModi();
                $('#txtDatea').focus();
                $('#txtNoa').attr('readonly', true).css('color','green').css('background-color','rgb(237,237,237)');
            }

            function btnPrint() {
                q_box('z_rc2a.aspx?;;;' + r_accy, '', "95%", "95%", q_getMsg("popPrint"));
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
				if (!as['rc2no']) {//不存檔條件
					as[bbsKey[1]] = '';
					return;
				}
				q_nowf();
				return true;
			}
            ///////////////////////////////////////////////////  以下提供事件程式，有需要時修改
            function refresh(recno) {
                _refresh(recno);
                if (q_getPara('sys.project').toUpperCase()!='SH'){
                	$('.acc').hide();
                }
                refreshBbs();
            }

            function readonly(t_para, empty) {
                _readonly(t_para, empty);
                refreshBbs();
            }

            function btnMinus(id) {
                _btnMinus(id);
                sum();
            }

            function btnPlus(org_htm, dest_tag, afield) {
                _btnPlus(org_htm, dest_tag, afield);
                if (q_tables == 's')
                    bbsAssign();
                /// 表身運算式
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
                width: 750px;
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
            }
            .dbbs {
                width: 1250px;
            }
            .tbbs a {
                font-size: medium;
            }
            input[type="text"], input[type="button"] {
                font-size: medium;
            }
            .num {
                text-align: right;
            }
            select {
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
		<div style="overflow: auto;display:block;">
			<!--#include file="../inc/toolbar.inc"-->
		</div>
		<div style="overflow: auto;display:block;width:1280px;">
			<div class="dview" id="dview">
				<table class="tview" id="tview"	>
					<tr>
						<td align="center" style="width:20px; color:black;"><a id='vewChk'> </a></td>
						<td align="center" style="width:120px; color:black;"><a id='vewNoa'> </a></td>
						<td align="center" style="width:80px; color:black;"><a id='vewDatea'> </a></td>
					</tr>
					<tr>
						<td><input id="chkBrow.*" type="checkbox"/></td>
						<td align="center" id='noa'>~noa</td>
						<td align="center" id='datea'>~datea</td>
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
						<td><input id="txtDatea" type="text" class="txt c1"/></td>
						<td><span> </span><a id="lblAcomp" class="lbl btn" > </a></td>
						<td colspan="3">
							<input id="txtCno" type="text" style="float:left;width:30%;"/>
							<input id="txtAcomp" type="text" style="float:left;width:70%;"/>
							<input id="txtNick"  type="text" style="display:none;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblNoa' class="lbl"> </a></td>
						<td><input id="txtNoa" type="text" class="txt c1"/></td>
						<td>
							<!--<input id="chkIscarrier" type="checkbox" style="float:left;"/>
							<a id="lblIscarrier" class="lbl" style="float:left;"> </a>-->
							<span> </span><a id="lblTgg" class="lbl btn"> </a>
						</td>
						<td colspan="3">
							<input id="txtTggno"  type="text" style="float:left;width:30%;"/>
							<input id="txtComp"  type="text" style="float:left;width:70%;"/>
						</td>
					</tr>
					<tr>
						<td><span> </span><a id='lblSerial' class="lbl"> </a></td>
						<td><input id="txtSerial"  type="text"  class="txt c1"/></td>
						<td><span> </span><a id='lblAddress' class="lbl"> </a></td>
						<td colspan="3"><input id="txtAddress" type="text" class="txt c1"/></td>
					</tr>
					<tr>
						<td><span> </span><a id='lblMon' class="lbl"> </a></td>
						<td><input id="txtMon" type="text" class="txt c1"/></td>
						<td><span> </span><a id='lblTaxtype' class="lbl"> </a></td>
						<td><select id="cmbTaxtype" class="txt c1"> </select></td>
						
						<td><span> </span><a id='lblTaxrate' class="lbl">稅率</a></td>
						<td><input id="txtTaxrate" type="text" class="txt c1 num"/></td>
						
						<!--<td><span> </span><a id='lblBuyer' class="lbl btn"> </a></td>
						<td colspan="3">
							<input id="txtBuyerno"  type="text" style="float:left;width:30%;"/>
							<input id="txtBuyer"  type="text" style="float:left;width:70%;"/>
						</td>-->
					</tr>
					<tr>
						<td><span> </span><a id='lblMoney' class="lbl"> </a></td>
						<td><input id="txtMoney" type="text" class="txt num c1" /></td>
						<td><span> </span><a id='lblTax' class="lbl"> </a></td>
						<td><input id="txtTax"  type="text" class="txt num c1" /></td>
						<td><span> </span><a id='lblTotal' class="lbl"> </a></td>
						<td><input id="txtTotal" type="text" class="txt num c1" /></td>
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
						<td><span> </span><a id='lblWorker' class="lbl"> </a></td>
						<td><input id="txtWorker" type="text" class="txt c1" /></td>
						<td><span> </span><a id='lblAccno' class="lbl"> </a></td>
						<td><input id="txtAccno"  type="text" class="txt c1" /></td>
						<td><span> </span><a id='lblCobtype' class="lbl"> </a></td>
						<td><input id="txtCobtype"  type="text" style="float:left;width:50%;"/></td>
						<!--<td><input id="txtProduct" type="text" class="txt c1 isST2" style="display: none;"/></td>-->
					</tr>
					<tr>
						<td><span> </span><a id="lblMemo" class="lbl" > </a></td>
						<td colspan='5'><input id="txtMemo" type="text" class="txt c1" /></td>
					</tr>
					<tr>
						<td> </td>
						<td><input type="checkbox" style="float:left;" id="chkIssend"/><span style="display:block;width:100px;float:left;">接收</span></td>
						<td><input type="checkbox" style="float:left;" id="chkIssendconfirm"/><span style="display:block;width:100px;float:left;">開立確認</span></td>
						<td><input type="checkbox" style="float:left;" id="chkIscancel"/><span style="display:block;width:100px;float:left;">作廢</span></td>
						<td><input type="checkbox" style="float:left;" id="chkIscancelconfirm"/><span style="display:block;width:100px;float:left;">作廢確認</span></td>
						<td><input type="button" style="display: none;" id="btnRc2" value="進貨單匯入"> </td>
					</tr>
				</table>
			</div>
			<input class="einvoice" type="button" id="btnA0102" title="A0102" value="發票確認" style="width:200px;height:50px;white-space:normal;display:none;"/>
			<span style="display:block;,width:5px;height:5px;"> </span>
			<input class="einvoice" type="button" id="btnA0202" title="A0202" value="作廢確認" style="width:200px;height:50px;white-space:normal;display:none;"/>
			<span style="display:block;,width:5px;height:30px;"> </span>
			<input class="einvoice" type="button" id="btnVccb" value="折讓／退回" style="width:200px;height:50px;white-space:normal;display:none;"/>
		</div>
		
		<div class='dbbs'>
			<table id="tbbs" class='tbbs' style=' text-align:center'>
				<tr style='color:white; background:#003366;' >
					<td  align="center" style="width:30px;"><input class="btn"  id="btnPlus" type="button" value='+' style="font-weight: bold;"  /></td>
					<td align="center" style="width:20px;"> </td>
					<td align="center" style="width:130px;"><a id='lblProductno'> </a></td>
					<td align="center" style="width:200px;"><a id='lblProduct'> </a></td>
					<td align="center" style="width:40px;"><a id='lblUnit'> </a></td>
					<td align="center" style="width:100px;"><a id='lblMount'> </a></td>
					<td align="center" style="width:100px;"><a id='lblPrice'> </a></td>
					<td align="center" style="width:150px;"><a id='lblMoneys'> </a></td>
					<td align="center"><a id='lblMemos'> </a></td>
					<td align="center" style="width:100px;" class="acc"><a id='lblAcc1'> </a></td>
					<td align="center" style="width:150px;" class="acc"><a id='lblAcc2'> </a></td>
				</tr>
				<tr  style='background:#cad3ff;'>
					<td align="center">
						<input class="btn"  id="btnMinus.*" type="button" value='-' style=" font-weight: bold;" />
						<input id="txtNoq.*" type="text" style="display: none;" />
					</td>
					<td><a id="lblNo.*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
					<td>
						<input id="btnProductno.*" type="button" value="." style="width: 5%;" />
						<input id="txtProductno.*" type="text" style="width: 80%;"/>
					</td>
					<td><input id="txtProduct.*"type="text" style="width:95%;"/></td>
					<td><input id="txtUnit.*" type="text" style="width:95%;"/></td>
					<td><input id="txtMount.*" type="text" style="width:95%;text-align: right;"/></td>
					<td><input id="txtPrice.*" type="text" style="width:95%;text-align: right;" /></td>
					<td><input id="txtMoney.*" type="text" style="width:95%;text-align: right;" /></td>
					<td><input id="txtMemo.*" type="text" style="width:95%;"/></td>
					<td class="acc">
                        <input class="acc" type="text" id="txtAcc1.*"  style="width:95%; float:left;" title="點擊滑鼠右鍵，列出明細。"/>
						<input type="button" id="btnAcc.*" style="display:none;" />
					</td>
					<td class="acc"><input class="acc" type="text" id="txtAcc2.*"  style="width:95%; float:left;"/></td>
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
						<td style="width:130px; text-align: center;">進貨單號</td>
						<td style="width:150px; text-align: center;" class="bbtuno">批號</td>
						<td style="width:100px; text-align: center;display: none;">品號</td>
						<td style="width:200px; text-align: center;">品名</td>
						<td style="width:100px; text-align: center;">數量<BR><a id='lblTot_mount'> </a></td>
						<td style="width:100px; text-align: center;">重量<BR><a id='lblTot_weight'> </a></td>
						<td style="width:100px; text-align: center;">單價</td>
						<td style="width:120px; text-align: center;">金額<BR><a id='lblTot_money'> </a></td>
					</tr>
					<tr>
						<td>
							<input id="btnMinut..*"  type="button" style="font-size: medium; font-weight: bold;" value="－"/>
							<input class="txt" id="txtNoq..*" type="text" style="display: none;"/>
						</td>
						<td><a id="lblNo..*" style="font-weight: bold;text-align: center;display: block;"> </a></td>
						<td>
							<input class="txt" id="txtRc2accy..*" type="text" style="width:95%;display:none;"/>
							<input class="txt" id="txtTablea..*" type="hidden"/>
							<input class="txt" id="txtRc2no..*" type="text" style="width:70%;float:left;"/>
							<input class="txt" id="txtRc2noq..*" type="text" style="width:20%;float:left;"/>
						</td>
						<td class="bbtuno"><input class="txt" id="txtUno..*" type="text" style="width:95%;float:left;"/></td>
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

