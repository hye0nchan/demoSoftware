using System;
using System.Collections.Generic;
using System.Text;

namespace restAPI
{
    public class Service : IService
    {
        // /data/{value}의 형시긍로 접속되면 호출되어 처리한다.
        public Response GetResponse(string value)
        {
            // Response 클래스 타입으로 리턴하면 자동으로 Json형식으로 변환한다.
            return new Response() { Result = "echo - " + value };
        }
    }
}
