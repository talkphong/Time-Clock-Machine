--------------Server
1.dotnet:
-tải dotnet: https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/sdk-10.0.201-windows-x64-installer
-tạo project dotnet: 
    dotnet new webapi -n MyServer
    cd MyServer
-thêm pakage test API:
    dotnet add package Swashbuckle.AspNetCore
-thêm code để test API trong file Program.cs:
    builder.Services.AddEndpointsApiExplorer();
    builder.Services.AddSwaggerGen();
    app.UseSwagger();
    app.UseSwaggerUI();
-chạy server: 
    dotnet 
    dotnet watch run //server tự refresh mỗi khi sửa code
-truy cập link test API:
    http://localhost:5032/swagger
-kết nối SQL server :
    dotnet add package Microsoft.EntityFrameworkCore.SqlServer
    dotnet add package Microsoft.EntityFrameworkCore.
-tạo Dbcontext:
    tạo file Data/AppDbContext.cs
