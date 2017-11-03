
<%@ Page Language="C#" Debug="true"%>
    <script language="c#" runat="server">     
        static string connString = @"Data Source=127.0.0.1,1799;Persist Security Info=True;User ID=sa;Password=artsql963;Database=";
        //static string connStringTNK = @"Data Source=127.0.0.1,1798;Persist Security Info=True;User ID=sa;Password=1qaz2wsx;Database=TNK";

        public class Invoices
        {
            public string product;
            public decimal mount;
            public decimal price;
            public decimal total;
        }
        public class Invoice
        {   
            public string InvoiceNumber;//發票號碼 
            public string InvoiceDate;  //日期 (yyymmdd)
            public string InvoiceTime;  //時間(hhmmss) 
            public string RandomNumber; //四位隨機碼
            public decimal SalesAmount;//銷售額
            public decimal TaxAmount;//稅額
            public decimal TotalAmount;//總計
            public string BuyerIdentifier;//買受人統編
            public string RepresentIdentifier;//代表店統編   目前QR Codde字串已不使用代表店，請直接輸入00000000      
            public string SellerIdentifier; //銷售店統編
            public string BusinessIdentifier;  //總公司統編   如無總公司，請輸入銷售店統編
            public string AESKey; //加解密金鑰
            public string Printmark;
            public string cno;
            public string acomp;

            public DateTime date;

            public string code39// 發票期別(5) + 發票字軌號碼(10) + 隨機碼(4)
            {
                get {
                    try
                    {
                        string year = this.InvoiceDate.Substring(0, 3);
                        string month = "00" + (Int32.Parse(this.InvoiceDate.Substring(3, 2)) + Int32.Parse(this.InvoiceDate.Substring(3, 2)) % 2).ToString();
                        month = month.Substring(month.Length - 2, 2);
                        return year + month + this.InvoiceNumber + this.RandomNumber;
                    }
                    catch (Exception e)
                    {
                        return "";
                    }
                }
            }
            public string qrcode
            {
                get {
                   // try
                   // {
                        com.tradevan.qrutil.QREncrypter qrEncrypter = new com.tradevan.qrutil.QREncrypter();
                        return qrEncrypter.QRCodeINV(this.InvoiceNumber, this.InvoiceDate, this.InvoiceTime
                        , this.RandomNumber, this.SalesAmount, this.TaxAmount, this.TotalAmount
                        , this.BuyerIdentifier, this.RepresentIdentifier, this.SellerIdentifier, this.BusinessIdentifier, this.AESKey)
                        + "**********:" + (this.bbs.Length > 11 ? "11" : this.bbs.Length.ToString())// 第一項產品放在 qrcode,剩下的都放在qrcode2,qrcode2最多記錄10筆,所以單張發票最多記載11筆明細
                        + ":" + this.bbs.Length.ToString() + ":1"  //統一 UTF-8 編碼
                        + ":" + this.bbs[0].product + ":" + this.bbs[0].mount.ToString("0.########") + ":" + this.bbs[0].price.ToString("0.########") + ":";
                    /*}
                    catch (Exception e)
                    {
                        return "";
                    }*/
                }
            }
            public string qrcode2
            {
                get
                {
                    string item = "**";
                    for (int i = 1; i < this.bbs.Length; i++)
                    {
                        if (i > 11) //最多顯示10筆
                            break;
                        item += this.bbs[i].product + ":" + this.bbs[i].mount.ToString("0.########") + ":" + this.bbs[i].price.ToString("0.########") + ":";
                    }
                    return item;
                }
            }

            public Invoices[] bbs;
        }
        /*
        1. 發票字軌 (10)：記錄發票完整10碼號碼。
        2. 發票開立日期 (7)：記錄發票3碼民國年份2碼月份2碼日期共7碼。
        3. 隨機碼 (4)：記錄發票上隨機碼4碼。
        4. 銷售額 (8)：記錄發票上未稅之金額總計8碼，將金額轉換以十六進位方式記載。
        若營業人銷售系統無法順利將稅項分離計算，則以00000000記載。
        5. 總計額 (8)：記錄發票上含稅總金額總計8碼，將金額轉換以十六進位方式記載。
        6. 買方統一編號 (8)：記錄發票上買受人統一編號，若買受人為一般消費者則以
        00000000記載。
        7. 賣方統一編號 (8)：記錄發票上賣方統一編號。
        8. 加密驗證資訊 (24)：將發票字軌10碼及隨機碼4碼以字串方式合併後使用 AES
        加密並採用 Base64 編碼轉換，AES所採用之金鑰產生方式請參考第叁、肆章
        及「加解密API使用說明書」。
        以上欄位總計77碼。下述資訊為接續以上資訊繼續延伸記錄，且每個欄位前皆以
        間隔符號“:” (冒號)區隔各記載事項，若左方二維條碼不敷記載，則繼續記載於
        右方二維條碼。
        9. 營業人自行使用區 (10位)：提供營業人自行放置所需資訊，若不使用則以10個
        “*”符號呈現。
        10.二維條碼記載完整品目筆數：記錄左右兩個二維條碼記載消費品目筆數，以十進
        位方式記載。
        11.該張發票交易品目總筆數：記錄該張發票記載總消費品目筆數，以十進位方式記
        載。
        12.中文編碼參數 (1位)：定義後續資訊的編碼規格，若以：
        (1) Big5編碼，則此值為0
        (2) UTF-8編碼，則此值為1
        (3) Base64編碼，則此值為2
        13.品名：商品名稱，請避免使用間隔符號“:”(冒號)於品名。
        */
        
        System.IO.MemoryStream stream = new System.IO.MemoryStream();
        string connectionString = "";
        public void Page_Load()
        {
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();

            string db = "st", invoiceNumber = "";
            if (Request.QueryString["invoice"] != null && Request.QueryString["invoice"].Length > 0)
                invoiceNumber = Request.QueryString["invoice"];
            if (Request.QueryString["db"] != null && Request.QueryString["db"].Length > 0)
                db = Request.QueryString["db"];
            //檢查是否有輸入參數
            if (invoiceNumber.Length == 0 || db.Length==0)
            {
                Response.Write("請輸入參數：發票號碼(invoice)、資料庫(db)");
                Response.End();
                return;
            }

            Invoice invoice = GetInvoice(db,invoiceNumber);

         /*   Response.Write(invoice.code39);
            Response.Write("<br>");
            Response.Write(invoice.qrcode);
            Response.End();
            return;*/
            
            //-----PDF--------------------------------------------------------------------------------------------------
            var doc1 = new iTextSharp.text.Document(iTextSharp.text.PageSize.A4);
            float width = doc1.PageSize.Width / (float)21.00 * (float)5.7;
            float height = doc1.PageSize.Height / (float)29.70 * (float)9.0;
            doc1 = new iTextSharp.text.Document(new iTextSharp.text.Rectangle(width, height), 0, 0, 0, 0);
            
            iTextSharp.text.pdf.PdfWriter pdfWriter = iTextSharp.text.pdf.PdfWriter.GetInstance(doc1, stream);
            //font
            iTextSharp.text.pdf.BaseFont bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            iTextSharp.text.pdf.BaseFont bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjhbd.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            iTextSharp.text.pdf.BaseFont bfNumber = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\ariblk.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            
            doc1.Open();
            iTextSharp.text.pdf.PdfContentByte cb = pdfWriter.DirectContent;
            doc1.NewPage();
            //============ 第一頁 ==============
            //一維條碼
            iTextSharp.text.Paragraph pa = new iTextSharp.text.Paragraph();            
            iTextSharp.text.pdf.Barcode39 barcode = new iTextSharp.text.pdf.Barcode39();
            barcode.Code = invoice.code39;
            barcode.AltText = "";
            iTextSharp.text.Image barcodeImage = barcode.CreateImageWithBarcode(cb, null, null);
            barcodeImage.ScalePercent(60f);
            barcodeImage.Alignment = iTextSharp.text.Element.ALIGN_CENTER;
            barcodeImage.SetAbsolutePosition(17,80);
            cb.AddImage(barcodeImage);
            
            //二維條碼
            if (invoice.qrcode.Length > 0)
            {
                iTextSharp.text.Image qrcode = iTextSharp.text.Image.GetInstance(QrCode(invoice.qrcode, 100, 100), iTextSharp.text.BaseColor.BLACK);
                qrcode.ScaleAbsolute(75f, 75f);
                qrcode.SetAbsolutePosition(10, 10);
                cb.AddImage(qrcode);
            }
            if (invoice.qrcode2.Length > 0)
            {
                iTextSharp.text.Image qrcode2 = iTextSharp.text.Image.GetInstance(QrCode(invoice.qrcode2, 100, 100), iTextSharp.text.BaseColor.BLACK);
                qrcode2.ScaleAbsolute(75f, 75f);
                qrcode2.SetAbsolutePosition(78, 10);
                cb.AddImage(qrcode2);
            }
            //文字
            cb.SetColorFill(iTextSharp.text.BaseColor.BLACK);
            cb.BeginText();
            //公司名稱
            cb.SetFontAndSize(bfChinese, 18);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER,invoice.acomp, width / 2, 220, 0);
            //電子發票證明聯

            if (invoice.Printmark == "Y")
            {
                cb.SetFontAndSize(bfChinese, 17);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "電子發票證明聯補印", width / 2, 200, 0);
            }
            else
            {
                cb.SetFontAndSize(bfChinese, 18);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "電子發票證明聯", width / 2, 200, 0);
            }
            //期別
            int n = Int32.Parse(invoice.InvoiceDate.Substring(3, 2)) + Int32.Parse(invoice.InvoiceDate.Substring(3, 2)) % 2;
            string value = invoice.InvoiceDate.Substring(0, 3).ToString() + "年"
                + ("0" + (n - 1).ToString()).Substring(("0" + (n - 1).ToString()).Length-2,2) + "-"
                + ("0" + n.ToString()).Substring(("0" + n.ToString()).Length - 2, 2) + "月";
            cb.SetFontAndSize(bold, 18);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, value, width / 2, 180, 0);
            //發票號碼
            cb.SetFontAndSize(bold, 19);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, invoice.InvoiceNumber, width / 2, 160, 0);
            //日期、時間
            cb.SetFontAndSize(bfChinese, 10);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, invoice.date.ToString("yyyy-MM-dd"), 18, 138, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, invoice.date.ToString("hh:mm:ss"), 80, 138, 0);
            //隨機碼、總計
            cb.SetFontAndSize(bfChinese, 10);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "隨機碼 "+invoice.RandomNumber.ToString(), 18, 124, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "總計  " + invoice.TotalAmount.ToString("0.########"), 90, 124, 0);
            //賣方
            cb.SetFontAndSize(bfChinese, 10);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "賣方", 18, 110, 0);
            cb.SetFontAndSize(bfChinese, 8);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, invoice.SellerIdentifier, 40, 110, 0);
            //買方
            if (invoice.BuyerIdentifier.Length > 0 && invoice.BuyerIdentifier != "00000000")
            {
                cb.SetFontAndSize(bfChinese, 10);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "買方", 90, 110, 0);
                cb.SetFontAndSize(bfChinese, 8);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, invoice.BuyerIdentifier, 112, 110, 0);
            }
            
            cb.EndText();
            
            // done
            doc1.Add(pa);
            //============ 產品明細 ==============
            /* doc1.NewPage();
             iTextSharp.text.Paragraph pa2 = new iTextSharp.text.Paragraph();
             cb.BeginText();
             //產品明細
             cb.SetFontAndSize(bfChinese, 10);
             cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "產品明細 " + invoice.SellerIdentifier, 18, 110, 0);
             cb.EndText();
             // done
             doc1.Add(pa2);*/
            doc1.Close();
            
            Response.ContentType = "application/octec-stream;";
            Response.AddHeader("Content-transfer-encoding", "binary");
            Response.AddHeader("Content-Disposition", "attachment;filename="+invoiceNumber+".pdf");
            Response.BinaryWrite(stream.ToArray());
            Response.End();
        }

        public Invoice GetInvoice(string db,string invoiceNumber)
        {
            Invoice invoice = new Invoice();

            System.Data.DataSet ds = new System.Data.DataSet();
            using (System.Data.SqlClient.SqlConnection connSource = new System.Data.SqlClient.SqlConnection(connString+db))
            {
                System.Data.SqlClient.SqlDataAdapter adapter = new System.Data.SqlClient.SqlDataAdapter();
                connSource.Open();
                string query = @"
            declare @tmp table(
        InvoiceNumber nvarchar(10)
        ,InvoiceDate nvarchar(20)
        ,InvoiceTime nvarchar(20)
        ,RandomNumber nvarchar(4)
        ,SalesAmount decimal(15,5)
        ,TaxAmount decimal(15,5)
        ,TotalAmount decimal(15,5)
        ,BuyerIdentifier nvarchar(10)     --買受人統編
        ,RepresentIdentifier nvarchar(10) --代表店統編   目前QR Codde字串已不使用代表店，請直接輸入00000000    
        ,SellerIdentifier nvarchar(10)    --銷售店統編
        ,BusinessIdentifier nvarchar(10)  --總公司統編   如無總公司，請輸入銷售店統編
        ,[date] datetime
        ,aes nvarchar(max)
        ,printmark nvarchar(max)
        ,cno nvarchar(20)
        ,acomp nvarchar(50)
    )
    insert into @tmp(InvoiceNumber,InvoiceDate,InvoiceTime,RandomNumber
        ,SalesAmount,TaxAmount,TotalAmount
        ,BuyerIdentifier,RepresentIdentifier,SellerIdentifier,BusinessIdentifier
        ,[date],aes,printmark,cno,acomp)
    select a.noa
		,replace(case when len(a.datea)=10 then dbo.AD2ChineseEraName(cast(a.datea as datetime)) else a.datea end,'/','')
		,replace(case when len(isnull(a.timea,''))=0 then '000000' else a.timea end,':','')
        ,case when len(isnull(a.randnumber,''))=0 then '0000' else a.randnumber end 
        ,a.[money],a.tax,a.total
         ,case when len(isnull(a.serial,''))=0 or a.serial='0000000000' then '00000000' else a.serial end
        ,'00000000',b.serial,b.serial
        ,cast( case when len(a.datea)=10 then a.datea else convert(nvarchar,dbo.ChineseEraName2AD(a.datea),111) end+' '+isnull(a.timea,'') as datetime)
        ,isnull(b.aes,'')
        ,isnull(a.printmark,'')
        ,a.cno,isnull(b.acomp,'')
    from vcca a 
    left join acomp b on a.cno=b.noa
    where a.noa=@invoiceNumber

	declare @tmps table(
		product nvarchar(max)
		,mount decimal(15,5)
		,price decimal(15,5)
		,total decimal(15,5)
	)
	insert into @tmps(product,mount,price,total)
	select replace(a.product,':','') --移除 :
        ,a.mount,a.price,isnull(a.[money],0)+isnull(a.[tax],0)
	from vccas a
	where a.noa=@invoiceNumber
	order by a.noq

    --回寫已列印
    update vcca set printmark='Y' where noa=@invoiceNumber
	
    select * from @tmp
    select * from @tmps
                ";

                System.Data.SqlClient.SqlCommand cmd = connSource.CreateCommand();
                //System.Data.SqlClient.SqlTransaction transaction;
                //transaction = connSource.BeginTransaction("SampleTransaction");
                cmd.CommandText = query;
                cmd.Connection = connSource;
                //cmd.Transaction = transaction;
                cmd.Parameters.AddWithValue("@invoiceNumber", invoiceNumber);
                adapter.SelectCommand = cmd;
                adapter.Fill(ds);
                connSource.Close();
            }

            foreach (System.Data.DataRow r in ds.Tables[0].Rows)
            {
                invoice.InvoiceNumber = System.DBNull.Value.Equals(r.ItemArray[0]) ? null : (System.String)r.ItemArray[0];
                invoice.InvoiceDate = System.DBNull.Value.Equals(r.ItemArray[1]) ? null : (System.String)r.ItemArray[1];
		        invoice.InvoiceTime = System.DBNull.Value.Equals(r.ItemArray[2]) ? null : (System.String)r.ItemArray[2];
		        invoice.RandomNumber = System.DBNull.Value.Equals(r.ItemArray[3]) ? null : (System.String)r.ItemArray[3];
		        invoice.SalesAmount = System.DBNull.Value.Equals(r.ItemArray[4]) ? 0 : (System.Decimal)r.ItemArray[4];
		        invoice.TaxAmount = System.DBNull.Value.Equals(r.ItemArray[5]) ? 0 : (System.Decimal)r.ItemArray[5];
		        invoice.TotalAmount = System.DBNull.Value.Equals(r.ItemArray[6]) ? 0 : (System.Decimal)r.ItemArray[6];
		        invoice.BuyerIdentifier = System.DBNull.Value.Equals(r.ItemArray[7]) ? null : (System.String)r.ItemArray[7];
		        invoice.RepresentIdentifier = System.DBNull.Value.Equals(r.ItemArray[8]) ? null : (System.String)r.ItemArray[8];  
		        invoice.SellerIdentifier = System.DBNull.Value.Equals(r.ItemArray[9]) ? null : (System.String)r.ItemArray[9];
                invoice.BusinessIdentifier = System.DBNull.Value.Equals(r.ItemArray[10]) ? null : (System.String)r.ItemArray[10];
                invoice.date = System.DBNull.Value.Equals(r.ItemArray[11]) ? System.DateTime.MinValue : (System.DateTime)r.ItemArray[11];
                invoice.AESKey = System.DBNull.Value.Equals(r.ItemArray[12]) ? null : (System.String)r.ItemArray[12];
                invoice.Printmark = System.DBNull.Value.Equals(r.ItemArray[13]) ? null : (System.String)r.ItemArray[13];
                invoice.cno = System.DBNull.Value.Equals(r.ItemArray[14]) ? null : (System.String)r.ItemArray[14];
                invoice.acomp = System.DBNull.Value.Equals(r.ItemArray[15]) ? null : (System.String)r.ItemArray[15];
            }
            invoice.bbs = new Invoices[ds.Tables[1].Rows.Count];
            int n = 0;
            foreach (System.Data.DataRow r in ds.Tables[1].Rows)
            {
                invoice.bbs[n] = new Invoices();
                invoice.bbs[n].product = System.DBNull.Value.Equals(r.ItemArray[0]) ? null : (System.String)r.ItemArray[0];
                invoice.bbs[n].mount = System.DBNull.Value.Equals(r.ItemArray[1]) ? 0 : (System.Decimal)r.ItemArray[1];
                invoice.bbs[n].price = System.DBNull.Value.Equals(r.ItemArray[2]) ? 0 : (System.Decimal)r.ItemArray[2];
                invoice.bbs[n].total = System.DBNull.Value.Equals(r.ItemArray[3]) ? 0 : (System.Decimal)r.ItemArray[3];
                n++;
            }

            return invoice;
        }

        public static System.Drawing.Bitmap QrCode(string code, int width, int height)
        {
            ZXing.BarcodeWriter bw = new ZXing.BarcodeWriter();
            bw.Format = ZXing.BarcodeFormat.QR_CODE;
            bw.Options.Hints.Add(ZXing.EncodeHintType.ERROR_CORRECTION, ZXing.QrCode.Internal.ErrorCorrectionLevel.L);
            bw.Options.Hints.Add(ZXing.EncodeHintType.CHARACTER_SET, "UTF-8");
            bw.Options.Hints.Add(ZXing.EncodeHintType.QR_VERSION, "6");
            bw.Options.Width = width;
            bw.Options.Height = height;
            System.Drawing.Bitmap bp = bw.Write(code);
            return bp;
        }
    </script>
