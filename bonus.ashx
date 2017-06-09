<%@ WebHandler Language="C#" Class="Handler" %>

using System;
using System.Web;
using System.Net;
//using System.Data.OleDb;
//using System.Data;
//using System.Data.SqlClient;
//using System.Collections.Generic;
//using System.Collections;

public class Handler : IHttpHandler
{
 
    public void ProcessRequest(HttpContext context)
    {
        System.Web.Script.Serialization.JavaScriptSerializer serializer = new System.Web.Script.Serialization.JavaScriptSerializer();
        string filename = "";
        try
        {
            //filename = context.Request.Headers["filename"];

            System.Text.Encoding encoding = System.Text.Encoding.UTF8;
            context.Response.ContentEncoding = encoding;
            int formSize = context.Request.TotalBytes;
            byte[] formData = context.Request.BinaryRead(formSize);
            string data = encoding.GetString(formData);
            if (data.Length >= (data.IndexOf("base64") + 7))
                formData = Convert.FromBase64String(data.Substring(data.IndexOf("base64") + 7));
            
            context.Response.Write(formData);
            context.Response.Flush();
        }
        catch (Exception e)
        {
            context.Response.Write(filename + "\n" + e.Message);
        }
        
        
        
        
        
        
        
        
        
        
        
        
        
      /*  HttpFileCollection files = context.Request.Files;
       
        for (int i = 0; i < files.Count; i++)
        {
            context.Response.Write("File: " + context.Server.HtmlEncode(files.AllKeys[i]) + "<br />");
            context.Response.Write("  size = " + files[i].ContentLength + "<br />");
            context.Response.Write("  content type = " + files[i].ContentType + "<br />");
        }

        context.Response.ContentType = "application/json";*/
      /*  context.Response.Write(serializer.Serialize(pout));

            foreach (string item in files.AllKeys)
            {
                
            }
        files.AllKeys
        
        
        arr1 = Files.AllKeys;  // This will get names of all files into a string array.
        for (loop1 = 0; loop1 < arr1.Length; loop1++)
        {
            Response.Write("File: " + Server.HtmlEncode(arr1[loop1]) + "<br />");
            Response.Write("  size = " + Files[loop1].ContentLength + "<br />");
            Response.Write("  content type = " + Files[loop1].ContentType + "<br />");
        }    
            
            
            
        
        //context.Response.Write("Hello World");

        string db = "st";
        if (context.Request.QueryString["db"] != null && context.Request.QueryString["db"].Length > 0)
            db = context.Request.QueryString["db"];

        string bdate = @"0990101";
        string edate = @"0990229";
        string vfpConnString = @"Provider=VFPOLEDB.1;Data Source=Z:\Qd_win\SE2\";

        //context.Response.Write(getData(vfpConnString, bdate, edate, context));*/
    }
    public bool IsReusable
    {
        get
        {
            return false;
        }
    }

    class Bonus
    {
        public string Main;
        public string invoiceYYYMM;
        public int TotRecordCnt;
        public int TotPrizeAmt;
        public string RecAwardBegin;
        public string RecAwardEnd;
    }
    
    class Bonuss
    {
        public string TCompanyBan;
        public string InvoiceYYYMM;
        public string InvoiceAxle;
        public string InvoiceNumber;
        public string Name;
        public string BAN;
        public string Address;
        public string InvoiceDate;
        public string InvoiceTime;
        public int TotalAmount;
        public string CarrierType;
        public string CarrierName;
        public string CarrierIdclear;
        public string CarrierIdHide;
        public string RandomNumber;
        public string PrizeType;
        public int PrizeAmt;
        public string BBAN;
        public string DepositMK;
        public string DataType;
        public string ExceptionCode;
        public string PrintFormat;
        public string UID;
    }
}