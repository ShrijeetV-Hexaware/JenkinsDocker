#FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build-env
#FROM mcr.microsoft.com/dotnet/sdk:5.0  AS build-env
FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine3.12  AS build-env

WORKDIR /app

# Copy csproj and restore as distinct layers
COPY ./*.sln .
COPY ./*.csproj .

RUN dotnet restore ./JenkinsDemo.sln

# Copy everything else and build
COPY . ./
#RUN rm CEDMA/appsettings.json
#RUN mv CEDMA/appsettings.Production.json CEDMA/appsettings.json

RUN dotnet publish ./JenkinsDemo.sln -c Release -o out

# Build runtime image

#FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
#FROM mcr.microsoft.com/dotnet/aspnet:5.0
FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine3.12


WORKDIR /app
COPY --from=build-env app/out .

EXPOSE 5000
ENTRYPOINT ["dotnet", "JenkinsDemo.dll"]

#CMD  ["./startApp.sh"]
#CMD dotnet CEDMA.dll --urls "http://*:80"
