using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace Deloitte.PipelineFramework
{
    /// <summary>
    /// Helper class to communicate with the ssisapi webservice.
    /// </summary>
    public class WebApi
    {
        /// <summary>
        /// The name under which the CrcHeaderCheck value is communicated in the Http Headers.
        /// </summary>
        public const string CrcHeaderName = "X-CRC-PLWEBAPI";

        /// <summary>
        /// Generates keys that are valid for 1 hour.
        /// </summary>
        /// <returns></returns>
        public static string GenerateCrcCheckHeader()
        {
            var crc = new HttpRequestCrcCheck();
            return crc.MakeKey(DateTime.Now.AddHours(1));
        }

        /// <summary>
        /// Validates if a Crc is valid.
        /// </summary>
        /// <param name="input">The crc string to check.</param>
        /// <returns>True when OK.</returns>
        public static bool ValidateCrc(string input)
        {
            var crc = new HttpRequestCrcCheck();
            return crc.ValidateKey(input);
        }

        /// <summary>
        /// The crc header that was created last for this instance.
        /// <para>Could be helpful for debugging, might be a tiny vulnaribility.</para>
        /// </summary>
        public string LastCrc { get; set; }

        /// <summary>
        /// The base-url class.
        /// </summary>
        public string Host { get; set; }

        /// <summary>
        /// The part of the url that defines the action to run on the host.
        /// </summary>
        public string Endpoint { get; set; }

        /// <summary>
        /// Constructs the url to call, based on the Host and Endpoint.
        /// </summary>
        public Uri Url { get { return new Uri(Host.TrimEnd('/') + "/" + Endpoint.TrimStart('/')); } }

        /// <summary>
        /// Constructs a new instance with default settings.
        /// </summary>
        public WebApi() { 
            Host = "https://entis-ssisapi.azurewebsites.net";
            Endpoint = "status";
        }

        /// <summary>
        /// Performs the actual call to the api.
        /// <para>This method performs a POST-request.</para>
        /// </summary>
        /// <param name="data">Data to send to the endpoint.</param>
        public void CallApi(object data)
        {
            using (var wc = new WebClientEx())
            {
                wc.Timeout = 180000;
                LastCrc = GenerateCrcCheckHeader();
                UTF8Encoding enc = new UTF8Encoding();
                var bytes = enc.GetBytes(JsonConvert.SerializeObject(data));
                wc.UseDefaultCredentials = true;
                wc.Headers[HttpRequestHeader.ContentType] = "application/json";
                wc.Headers[HttpRequestHeader.Accept] = "application/json";
                wc.Headers[CrcHeaderName] = LastCrc;
                //wc.Headers[HttpRequestHeader.ContentLength] = bytes.Length.ToString();
                wc.UploadData(Url, "POST", bytes);
            }
        }
    }
    /// <summary>
    /// Wrapper class to accomodate setting of Timeout
    /// </summary>
    public class WebClientEx : WebClient
    {
        /// <summary>
        /// Timeout in ms.
        /// </summary>
        public int? Timeout { get; set; }

        /// <summary>
        /// Sets the timeout when it has been set.
        /// </summary>
        /// <param name="address">The url to send data to.</param>
        /// <returns>The request</returns>
        protected override WebRequest GetWebRequest(Uri address)
        {
            var request = base.GetWebRequest(address);
            int t = Timeout ?? -1;
            if (t != -1) request.Timeout = t;
            return request;
        }
    }
}
