using System;
using Azure.Storage.Blobs;
using Azure;
using Azure.ResourceManager;
using Azure.Identity;
using System.IO;
using System.Collections;
using Azure.ResourceManager.Resources;


string[] commands = Environment.GetCommandLineArgs();
foreach(string command in commands)
{
    Console.WriteLine(command);
}

ArmClient client = new ArmClient(new DefaultAzureCredential());

// Next we get a resource group object
// ResourceGroupResource is a [Resource] object from above
SubscriptionResource subscription = await client.GetDefaultSubscriptionAsync();
ResourceGroupCollection resourceGroups = subscription.GetResourceGroups();
ResourceGroupResource resourceGroup = await resourceGroups.GetAsync("guyResourceGroup");

Console.WriteLine();

var list = resourceGroup.GetGenericResources().ToList();

foreach (var resource in list)
{
    Console.WriteLine(resource.Data.Id);
    Console.WriteLine(resource.Data.Name);
    // resource.Data.
    // var a = resource.Get().GetRawResponse().Content;
    // a.
}

// IDictionary data = Environment.GetEnvironmentVariables();
  
//     // Display the details with key and value
//     foreach (DictionaryEntry i in data)
//     {
//         Console.WriteLine("{0}:{1}", i.Key, i.Value);
//     }



// const string connectionString = "DefaultEndpointsProtocol=https;AccountName=devstorel4qwjrlzlsbu61;AccountKey=TlA0XyWvBffdDnKnoGQpQkgfvhEZ/zi5urNDzSAEYsedv8XWT3Qc6vJOFWEq1OoCrhwKUm4vvHkc+AStMoaKOg==;EndpointSuffix=core.windows.net";
// BlobServiceClient client = new BlobServiceClient(connectionString);
// // BlobServiceClient client = new BlobServiceClient(
// //         new Uri("https://devstorel4qwjrlzlsbu61.blob.core.windows.net"),
// //         new AzureCliCredential());

// string containerName = "guystorageblobs" + Guid.NewGuid().ToString();

// BlobContainerClient containerClient = await client.CreateBlobContainerAsync(containerName, Azure.Storage.Blobs.Models.PublicAccessType.BlobContainer);
// Console.WriteLine(containerClient.AccountName);

// string localPath = "data";
// Directory.CreateDirectory(localPath);
// string fileName = "quickstart" + Guid.NewGuid().ToString() + ".txt";
// string localFilePath = Path.Combine(localPath, fileName);

// await File.WriteAllTextAsync(localFilePath, "Hello, Blob!");

// BlobClient blob = containerClient.GetBlobClient(fileName);

// Console.WriteLine("Uploading to Blob storage as blob:\n\t {0}\n", blob.Uri);

// // Upload data from the local file
// await blob.UploadAsync(localFilePath, true);