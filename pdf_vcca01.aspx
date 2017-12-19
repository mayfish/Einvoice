
<%@ Page Language="C#" Debug="true"%>
    <script language="c#" runat="server">    
        string filePath = @"C:\inetpub\wwwroot\htm\htm\";
        static string connString = @"Data Source=127.0.0.1,1799;Persist Security Info=True;User ID=sa;Password=artsql963;Database=";
        static float sizeW = 5.7f;
        //EPSON TM-T70II 表頭有1.5CM空白
        //不過紙張要設定7.4CM
        static float sizeH = 7.3f;

        public class Result
        {
            public int status = 1;
            public string filename = "";
            public string message = "";
        }
        
        public class Invoices
        {
            public string product;
            public decimal mount;
            public decimal price;
            public decimal total;
            public string cmount;
            public string cprice;
            public string ctotal;
        }
        public class Invoice
        {
            public int n = 0;
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
            public string logo;
            public DateTime date;

            public string SellerAddress;//營業人地址，明細列印用
            public string SellerTel;//營業人電話，明細列印用
            public string InvoiceTaxtype;
            public string cmoney, ctax, ctotal;

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
                        if (System.Text.Encoding.UTF8.GetBytes(item).Length > 100)
                            break;
                        if (i > 6) //最多顯示10筆
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
        string connectionString = "";
        public void Page_Load()
        {
            System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
            string db = "st", binvono = "", einvono = "";
           
            bool isdetail = true, isautoprint=false;
            if (Request.QueryString["db"] != null && Request.QueryString["db"].Length > 0)
                db = Request.QueryString["db"];
            if (Request.QueryString["binvono"] != null && Request.QueryString["binvono"].Length > 0)
                binvono = Request.QueryString["binvono"];
            if (Request.QueryString["einvono"] != null && Request.QueryString["einvono"].Length > 0)
                einvono = Request.QueryString["einvono"];
            if (Request.QueryString["isdetail"] != null && Request.QueryString["isdetail"].Length > 0)
                isdetail = Request.QueryString["isdetail"].ToUpper()=="TRUE"?true:false;
            if (Request.QueryString["isautoprint"] != null && Request.QueryString["isautoprint"].Length > 0)
                isautoprint = Request.QueryString["isautoprint"].ToUpper() == "TRUE" ? true : false;
            //檢查是否有輸入參數
            if (binvono.Length == 0 || einvono.Length == 0 || db.Length==0)
            {
                Response.Write("請輸入參數：發票號碼(binvono、einvono)、資料庫(db)");
                Response.End();
                return;
            }

            Invoice[] invoice = GetInvoice(db,binvono,einvono);
            ArrayList filename = new ArrayList();

            float width,height,bbmH,bbsH;
            iTextSharp.text.Document doc1;
            System.IO.MemoryStream stream;
            //字型
            iTextSharp.text.pdf.BaseFont bfChinese, bold;
            if (Environment.OSVersion.Version.Major > 6)
            {
                bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttc,0", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
                bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttc,1", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            }
            else
            {
                bfChinese = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjh.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
                bold = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\msjhbd.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
            }
            iTextSharp.text.pdf.BaseFont bfNumber = iTextSharp.text.pdf.BaseFont.CreateFont(@"C:\windows\fonts\ariblk.ttf", iTextSharp.text.pdf.BaseFont.IDENTITY_H, iTextSharp.text.pdf.BaseFont.NOT_EMBEDDED);
                
            //產生PDF實體檔用
            string uFileName;
            System.IO.FileStream pFileStream;
            
            for (int i = 0; i < invoice.Length; i++)
            {
                if (invoice[i].BuyerIdentifier.Length > 0 && invoice[i].BuyerIdentifier.Replace("0","").Length>0)
                
                {
                    //B2C   發票、明細印在同一張
                    stream = new System.IO.MemoryStream();
                    doc1 = new iTextSharp.text.Document(iTextSharp.text.PageSize.A4);
                    width = doc1.PageSize.Width / (float)21.00 * sizeW;
                    bbmH = (float)Math.Round(doc1.PageSize.Height / (float)29.70 * sizeH, 3);
                    bbsH = 50 + (invoice[i].bbs.Length == 0 ? 0 : (invoice[i].bbs.Length - 1) * 10) + 30;
                    height = bbmH + bbsH;

                    //start
                    stream = new System.IO.MemoryStream();
                    doc1 = new iTextSharp.text.Document(new iTextSharp.text.Rectangle(width, height), 0, 0, 0, 0);
                    iTextSharp.text.pdf.PdfWriter pdfWriter = iTextSharp.text.pdf.PdfWriter.GetInstance(doc1, stream);

                    doc1.Open();
                    iTextSharp.text.pdf.PdfContentByte cb = pdfWriter.DirectContent;
                    if (isautoprint)
                    {
                        iTextSharp.text.pdf.PdfAction jAction = iTextSharp.text.pdf.PdfAction.JavaScript("this.print(true);\r", pdfWriter);
                        pdfWriter.AddJavaScript(jAction);
                    }
                    doc1.NewPage();
                    //發票
                    Content(invoice[i], doc1, cb, bfChinese, bold, width, height, bbmH, bbsH);
                    //明細
                    if (isdetail)
                        Detail(invoice[i], doc1, cb, bfChinese, bold, width, height, bbmH, bbsH);
                    //產生PDF檔案
                    doc1.Close();
                    uFileName = string.Format(@"{0}.pdf", Guid.NewGuid());
                    pFileStream = null;
                    try
                    {
                        pFileStream = new System.IO.FileStream(filePath + uFileName, System.IO.FileMode.OpenOrCreate);
                        pFileStream.Write(stream.ToArray(), 0, stream.ToArray().Length);
                    }
                    catch (Exception e)
                    {
                        uFileName = "";
                    }
                    finally
                    {
                        if (pFileStream != null)
                            pFileStream.Close();
                    }
                    stream.Close();
                    filename.Add(uFileName);   
                }else
                {
                    //B2B  發票、明細要分開
                    stream = new System.IO.MemoryStream();
                    doc1 = new iTextSharp.text.Document(iTextSharp.text.PageSize.A4);
                    width = doc1.PageSize.Width / (float)21.00 * sizeW;
                    bbmH = (float)Math.Round(doc1.PageSize.Height / (float)29.70 * sizeH, 3);
                    bbsH = 50 + (invoice[i].bbs.Length == 0 ? 0 : (invoice[i].bbs.Length - 1) * 10) + 30;
                    height = bbmH;

                    //第一頁
                    stream = new System.IO.MemoryStream();
                    doc1 = new iTextSharp.text.Document(new iTextSharp.text.Rectangle(width, height), 0, 0, 0, 0);
                    iTextSharp.text.pdf.PdfWriter pdfWriter = iTextSharp.text.pdf.PdfWriter.GetInstance(doc1, stream);

                    doc1.Open();
                    iTextSharp.text.pdf.PdfContentByte cb = pdfWriter.DirectContent;
                    if (isautoprint)
                    {
                        iTextSharp.text.pdf.PdfAction jAction = iTextSharp.text.pdf.PdfAction.JavaScript("this.print(true);\r", pdfWriter);
                        pdfWriter.AddJavaScript(jAction);
                    }
                    doc1.NewPage();
                    Content(invoice[i], doc1, cb, bfChinese, bold, width, height, bbmH, bbsH);
                    doc1.Close();
                    //產生PDF檔案 -- 發票
                    uFileName = string.Format(@"{0}.pdf", Guid.NewGuid());
                    pFileStream = null;
                    try
                    {
                        pFileStream = new System.IO.FileStream(filePath + uFileName, System.IO.FileMode.OpenOrCreate);
                        pFileStream.Write(stream.ToArray(), 0, stream.ToArray().Length);
                    }
                    catch (Exception e)
                    {
                        uFileName = "";
                    }
                    finally
                    {
                        if (pFileStream != null)
                            pFileStream.Close();
                    }
                    stream.Close();
                    filename.Add(uFileName);
                    
                    //第二頁  明細聯
                    if (isdetail)
                    {
                        stream = new System.IO.MemoryStream();
                        //-----PDF--------------------------------------------------------------------------------------------------
                        bbsH = bbsH < width ? width : bbsH;
                        height = bbsH;
                        doc1 = new iTextSharp.text.Document(new iTextSharp.text.Rectangle(width, height), 0, 0, 0, 0);
                        pdfWriter = iTextSharp.text.pdf.PdfWriter.GetInstance(doc1, stream);
                        
                        doc1.Open();
                        cb = pdfWriter.DirectContent;
                        if (isautoprint)
                        {
                            iTextSharp.text.pdf.PdfAction jAction = iTextSharp.text.pdf.PdfAction.JavaScript("this.print(true);\r", pdfWriter);
                            pdfWriter.AddJavaScript(jAction);
                        }
                        doc1.NewPage();
                        Detail(invoice[i], doc1, cb, bfChinese, bold, width, height, bbmH, bbsH);
                        doc1.Close();
                        //產生PDF檔案 -- 明細聯
                        uFileName = string.Format(@"{0}.pdf", Guid.NewGuid());
                        pFileStream = null;
                        try
                        {
                            pFileStream = new System.IO.FileStream(filePath + uFileName, System.IO.FileMode.OpenOrCreate);
                            pFileStream.Write(stream.ToArray(), 0, stream.ToArray().Length);
                        }
                        catch (Exception e)
                        {
                            uFileName = "";
                        }
                        finally
                        {
                            if (pFileStream != null)
                                pFileStream.Close();
                        }
                        stream.Close();
                        filename.Add(uFileName);
                    }
                }
                
            }
            Response.Write(serializer.Serialize(filename));
            Response.End();
        }

        public void Content(Invoice invoice, iTextSharp.text.Document doc1, iTextSharp.text.pdf.PdfContentByte cb, iTextSharp.text.pdf.BaseFont bfChinese, iTextSharp.text.pdf.BaseFont bold, float width, float height, float bbmH, float bbsH)
        {
            //--------------------------------------------------------------
            //避免印表機不印空白頁
            //頁首
            cb.MoveTo(0, height - 1);
            cb.LineTo(1, height - 1);
            //頁尾
            for (int i = 0; i < 130; i+=3)
            {
                cb.MoveTo(i, height - bbmH + 1);
                cb.LineTo(i+1, height - bbmH + 1);
            }
            cb.Stroke();
            //--------------------------------------------------------------

            cb.SetFontAndSize(bfChinese, 8);
            //二維條碼
            if (invoice.qrcode.Length > 0)
              {
                  iTextSharp.text.Image qrcode = iTextSharp.text.Image.GetInstance(QrCode(invoice.qrcode, 100, 100), iTextSharp.text.BaseColor.BLACK);
                  qrcode.ScaleAbsolute(70f, 70f);
                  qrcode.SetAbsolutePosition(-3, height - bbmH + 5);
                  cb.AddImage(qrcode);
              }
              if (invoice.qrcode2.Length > 0)
              {
                  iTextSharp.text.Image qrcode2 = iTextSharp.text.Image.GetInstance(QrCode(invoice.qrcode2, 100, 100), iTextSharp.text.BaseColor.BLACK);
                  qrcode2.ScaleAbsolute(70f, 70f);
                  qrcode2.SetAbsolutePosition(65, height - bbmH + 5);
                  cb.AddImage(qrcode2);
              }
              //一維條碼
              iTextSharp.text.Paragraph pa = new iTextSharp.text.Paragraph();
              iTextSharp.text.pdf.Barcode39 barcode = new iTextSharp.text.pdf.Barcode39();
              barcode.Code = invoice.code39;
              barcode.AltText = "";
              barcode.BarHeight = 25;
              barcode.Baseline = 3;
              iTextSharp.text.Image barcodeImage = barcode.CreateImageWithBarcode(cb, null, null);
              barcodeImage.ScalePercent(60f);
              barcodeImage.Alignment = iTextSharp.text.Element.ALIGN_CENTER;
              barcodeImage.SetAbsolutePosition(2, height - bbmH + 75);
              cb.AddImage(barcodeImage);
              //--------------------------------------------文字--------------------------------------------------------
              cb.BeginText();
              //賣方
              cb.SetFontAndSize(bfChinese, 9);
              cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "賣方", 5, height - bbmH + 100, 0);
              cb.SetFontAndSize(bfChinese, 8);
              cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, invoice.SellerIdentifier, 25, height - bbmH + 100, 0);
              //買方
              if (invoice.BuyerIdentifier.Length > 0 && invoice.BuyerIdentifier != "00000000")
              {
                  cb.SetFontAndSize(bfChinese, 9);
                  cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "買方", 75, height - bbmH + 100, 0);
                  cb.SetFontAndSize(bfChinese, 8);
                  cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, invoice.BuyerIdentifier, 95, height - bbmH + 100, 0);
              }
              //隨機碼、總計
              cb.SetFontAndSize(bfChinese, 9);
              cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "隨機碼 " + invoice.RandomNumber.ToString(), 5, height - bbmH + 110, 0);
              cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "總計  " + invoice.TotalAmount.ToString("0.########"), 75, height - bbmH + 110, 0);
              //日期、時間
              cb.SetFontAndSize(bfChinese, 9);
              cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, invoice.date.ToString("yyyy-MM-dd"), 5, height - bbmH + 120, 0);
              cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, invoice.date.ToString("hh:mm:ss"), 65, height - bbmH + 120, 0);
              //發票號碼
              cb.SetFontAndSize(bold, 19);
              cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, invoice.InvoiceNumber, width / 2 - (width / (float)5.7 * (float)0.4), height - bbmH + 135, 0);
              //期別
              int n = Int32.Parse(invoice.InvoiceDate.Substring(3, 2)) + Int32.Parse(invoice.InvoiceDate.Substring(3, 2)) % 2;
              string value = invoice.InvoiceDate.Substring(0, 3).ToString() + "年"
                  + ("0" + (n - 1).ToString()).Substring(("0" + (n - 1).ToString()).Length - 2, 2) + "-"
                  + ("0" + n.ToString()).Substring(("0" + n.ToString()).Length - 2, 2) + "月";
              cb.SetFontAndSize(bold, 18);
              cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, value, width / 2 - (width / (float)5.7 * (float)0.4), height - bbmH + 152, 0);
              //電子發票證明聯
              if (invoice.Printmark == "Y")
              {
                  cb.SetFontAndSize(bfChinese, (float)14);
                  cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "電子發票證明聯補印", width / 2 - (width / (float)5.7 * (float)0.4), height - bbmH + 170, 0);
              }
              else
              {
                  cb.SetFontAndSize(bfChinese, 17);
                  cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, "電子發票證明聯", width / 2 - (width / (float)5.7 * (float)0.4), height - bbmH + 170, 0);
              }
              cb.EndText();
              //--------------------------------------------------LOGO-----------------------------------------------------------------------
              //有LOGO就印LOGO,不然就印公司名稱
              try
              {
                  //LOGO    檔名要等同於公司編號
                  System.Drawing.Image image = System.Drawing.Image.FromFile(Server.MapPath("/einvoice/" + invoice.cno + ".png"), true);          
                  iTextSharp.text.Image logo = iTextSharp.text.Image.GetInstance(image, System.Drawing.Imaging.ImageFormat.Bmp);
                  //調整圖片大小
                  logo.ScalePercent(20f);
                  logo.SetAbsolutePosition(5, height - bbmH + 182);
                  doc1.Add(logo);
              }
              catch
              {
                  //公司名稱
                  cb.SetFontAndSize(bfChinese, 16);
                  cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_CENTER, invoice.acomp, width / 2 - (width / (float)5.7 * (float)0.3), height - bbmH + 188, 0);
              }
        }

        public void Detail(Invoice invoice, iTextSharp.text.Document doc1, iTextSharp.text.pdf.PdfContentByte cb, iTextSharp.text.pdf.BaseFont bfChinese, iTextSharp.text.pdf.BaseFont bold, float width, float height, float bbmH, float bbsH)
        {
            cb.BeginText();
            //營業人統編,地址,電話
            cb.SetFontAndSize(bold, 7);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "營業人統編：", 2, bbsH - 10, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "地址：", 2, bbsH - 20, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "電話：", 2, bbsH - 30, 0);
            cb.SetFontAndSize(bfChinese, 7);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, invoice.SellerIdentifier, 45, bbsH - 10, 0);
            cb.SetFontAndSize(bold, 6);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, invoice.SellerAddress, 22, bbsH - 20, 0);
            cb.SetFontAndSize(bold, 7);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, invoice.SellerTel, 22, bbsH - 30, 0);
            //品名,數量,單價
            cb.SetFontAndSize(bold, 7);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "品名", 2, bbsH - 40, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "數量", 90, bbsH - 40, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "單價", 120, bbsH - 40, 0);
            cb.EndText();
            cb.MoveTo(2, bbsH - 42);
            cb.LineTo(120, bbsH - 42);
            cb.Stroke();
            cb.BeginText();
            cb.SetFontAndSize(bfChinese, 7);
            float top = bbsH - 50f;
            for (int i = 0; i < invoice.bbs.Length; i++)
            {
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, invoice.bbs[i].product, 2, top - i * 10, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, invoice.bbs[i].cprice, 90, top - i * 10, 0);
                cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, invoice.bbs[i].cmount, 120, top - i * 10, 0);

            }
            //銷售額,營業稅,(應稅、零稅率、免稅),總 計
            top = bbsH - 50f - (invoice.bbs.Length == 0 ? 0 : (invoice.bbs.Length - 1) * 10);
            cb.EndText();
            cb.MoveTo(2, top-2);
            cb.LineTo(120, top-2);
            cb.Stroke();
            cb.BeginText();
            
            cb.SetFontAndSize(bold, 7);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "銷售額：", 2, top - 10, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "營業稅：", 2, top - 20, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_LEFT, "總 計：", 2, top - 30, 0);
            cb.SetFontAndSize(bfChinese, 7);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, invoice.cmoney, 120, top - 10, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, "("+invoice.InvoiceTaxtype+")", 50, top - 20, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, invoice.ctax, 120, top - 20, 0);
            cb.ShowTextAligned(iTextSharp.text.pdf.PdfContentByte.ALIGN_RIGHT, invoice.ctotal, 120, top - 30, 0);
            
            cb.EndText();
            doc1.Close();
        }
        public Invoice[] GetInvoice(string db, string binvono, string einvono)
        {
            System.Data.DataSet ds = new System.Data.DataSet();
            using (System.Data.SqlClient.SqlConnection connSource = new System.Data.SqlClient.SqlConnection(connString + db))
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
        ,logo nvarchar(max)
        ,n int
        ,SellerAddress nvarchar(max)
        ,SellerTel nvarchar(max)
        ,InvoiceTaxtype nvarchar(20)
    )
    insert into @tmp(InvoiceNumber,InvoiceDate,InvoiceTime,RandomNumber
        ,SalesAmount,TaxAmount,TotalAmount
        ,BuyerIdentifier,RepresentIdentifier,SellerIdentifier,BusinessIdentifier
        ,[date],aes,printmark,cno,acomp,logo,SellerAddress,SellerTel,InvoiceTaxtype)
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
        ,c.img
        ,b.addr_invo,b.tel
        ,case a.taxtype when '2' then '零稅率' when '4' then '免稅' when '6' then '作廢' else '應稅' end
    from vcca a 
    left join acomp b on a.cno=b.noa
    left join logo c on a.cno=c.noa
    where a.noa between @binvono and @einvono

	declare @tmps table(
		InvoiceNumber nvarchar(10)
		,product nvarchar(max)
		,mount decimal(15,5)
		,price decimal(15,5)
		,total decimal(15,5)
	)
	insert into @tmps(InvoiceNumber,product,mount,price,total)
	select a.noa,replace(a.product,':','') --移除 :
        ,a.mount,a.price,isnull(a.[money],0)+isnull(a.[tax],0)
	from vccas a
	left join @tmp b on b.InvoiceNumber=a.noa
	where b.InvoiceNumber is not null
	order by a.noa,a.noq
	
	update @tmp set n = b. n
	from @tmp a
	left join (select InvoiceNumber,count(1) n from @tmps group by InvoiceNumber) b on a.InvoiceNumber=b.InvoiceNumber
    --回寫已列印
    update vcca set printmark='Y'
	from vcca a
	left join @tmp b on a.noa=b.InvoiceNumber
	where b.InvoiceNumber is not null
	
    select * 
        ,dbo.getComma(SalesAmount,-1)
		,dbo.getComma(TaxAmount,-1)
		,dbo.getComma(TotalAmount,-1)
    from @tmp
    select *
		,dbo.getComma(mount,-1)
		,dbo.getComma(price,-1)
		,dbo.getComma(total,-1)
    from @tmps
                ";

                System.Data.SqlClient.SqlCommand cmd = connSource.CreateCommand();
                cmd.CommandText = query;
                cmd.Connection = connSource;
                //cmd.Transaction = transaction;
                cmd.Parameters.AddWithValue("@binvono", binvono);
                cmd.Parameters.AddWithValue("@einvono", einvono);
                adapter.SelectCommand = cmd;
                adapter.Fill(ds);
                connSource.Close();
            }
            Invoice[] bbm = new Invoice[ds.Tables[0].Rows.Count];
            int n = 0, m = 0;
            foreach (System.Data.DataRow r in ds.Tables[0].Rows)
            {
                bbm[n] = new Invoice();
                bbm[n].InvoiceNumber = System.DBNull.Value.Equals(r.ItemArray[0]) ? null : (System.String)r.ItemArray[0];
                bbm[n].InvoiceDate = System.DBNull.Value.Equals(r.ItemArray[1]) ? null : (System.String)r.ItemArray[1];
                bbm[n].InvoiceTime = System.DBNull.Value.Equals(r.ItemArray[2]) ? null : (System.String)r.ItemArray[2];
                bbm[n].RandomNumber = System.DBNull.Value.Equals(r.ItemArray[3]) ? null : (System.String)r.ItemArray[3];
                bbm[n].SalesAmount = System.DBNull.Value.Equals(r.ItemArray[4]) ? 0 : (System.Decimal)r.ItemArray[4];
                bbm[n].TaxAmount = System.DBNull.Value.Equals(r.ItemArray[5]) ? 0 : (System.Decimal)r.ItemArray[5];
                bbm[n].TotalAmount = System.DBNull.Value.Equals(r.ItemArray[6]) ? 0 : (System.Decimal)r.ItemArray[6];
                bbm[n].BuyerIdentifier = System.DBNull.Value.Equals(r.ItemArray[7]) ? null : (System.String)r.ItemArray[7];
                bbm[n].RepresentIdentifier = System.DBNull.Value.Equals(r.ItemArray[8]) ? null : (System.String)r.ItemArray[8];
                bbm[n].SellerIdentifier = System.DBNull.Value.Equals(r.ItemArray[9]) ? null : (System.String)r.ItemArray[9];
                bbm[n].BusinessIdentifier = System.DBNull.Value.Equals(r.ItemArray[10]) ? null : (System.String)r.ItemArray[10];
                bbm[n].date = System.DBNull.Value.Equals(r.ItemArray[11]) ? System.DateTime.MinValue : (System.DateTime)r.ItemArray[11];
                bbm[n].AESKey = System.DBNull.Value.Equals(r.ItemArray[12]) ? null : (System.String)r.ItemArray[12];
                bbm[n].Printmark = System.DBNull.Value.Equals(r.ItemArray[13]) ? null : (System.String)r.ItemArray[13];
                bbm[n].cno = System.DBNull.Value.Equals(r.ItemArray[14]) ? null : (System.String)r.ItemArray[14];
                bbm[n].acomp = System.DBNull.Value.Equals(r.ItemArray[15]) ? null : (System.String)r.ItemArray[15];
                bbm[n].logo = System.DBNull.Value.Equals(r.ItemArray[16]) ? null : (System.String)r.ItemArray[16];
                bbm[n].n = System.DBNull.Value.Equals(r.ItemArray[17]) ? 0 : (System.Int32)r.ItemArray[17];
                bbm[n].SellerAddress = System.DBNull.Value.Equals(r.ItemArray[18]) ? "" : (System.String)r.ItemArray[18];
                bbm[n].SellerTel = System.DBNull.Value.Equals(r.ItemArray[19]) ? "" : (System.String)r.ItemArray[19];
                bbm[n].InvoiceTaxtype = System.DBNull.Value.Equals(r.ItemArray[20]) ? "" : (System.String)r.ItemArray[20];
                bbm[n].cmoney = System.DBNull.Value.Equals(r.ItemArray[21]) ? "" : (System.String)r.ItemArray[21];
                bbm[n].ctax = System.DBNull.Value.Equals(r.ItemArray[22]) ? "" : (System.String)r.ItemArray[22];
                bbm[n].ctotal = System.DBNull.Value.Equals(r.ItemArray[23]) ? "" : (System.String)r.ItemArray[23];
                
                bbm[n].bbs = new Invoices[bbm[n].n];
                m = 0;
                foreach (System.Data.DataRow s in ds.Tables[1].Rows)
                {
                    if (bbm[n].InvoiceNumber != (System.DBNull.Value.Equals(s.ItemArray[0]) ? null : (System.String)s.ItemArray[0]))
                        continue;
                    bbm[n].bbs[m] = new Invoices();
                    bbm[n].bbs[m].product = System.DBNull.Value.Equals(s.ItemArray[1]) ? null : (System.String)s.ItemArray[1];
                    bbm[n].bbs[m].mount = System.DBNull.Value.Equals(s.ItemArray[2]) ? 0 : (System.Decimal)s.ItemArray[2];
                    bbm[n].bbs[m].price = System.DBNull.Value.Equals(s.ItemArray[3]) ? 0 : (System.Decimal)s.ItemArray[3];
                    bbm[n].bbs[m].total = System.DBNull.Value.Equals(s.ItemArray[4]) ? 0 : (System.Decimal)s.ItemArray[4];
                    bbm[n].bbs[m].cmount = System.DBNull.Value.Equals(s.ItemArray[5]) ? null : (System.String)s.ItemArray[5];
                    bbm[n].bbs[m].cprice = System.DBNull.Value.Equals(s.ItemArray[6]) ? null : (System.String)s.ItemArray[6];
                    bbm[n].bbs[m].ctotal = System.DBNull.Value.Equals(s.ItemArray[7]) ? null : (System.String)s.ItemArray[7];
                    m++;
                }

                n++;
            }
            return bbm;
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
