#r "nuget: Azure.Storage.Blobs, 12.16.0"

using System.Collections;
using Azure.Storage.Blobs;
using Azure.Storage.Blobs.Models;
using Azure.Storage.Sas;

await Main();

async Task Main()
{
    string connectionStringA = Environment.GetCommandLineArgs()[2];
    string connectionStringB = Environment.GetCommandLineArgs()[3];

    BlobContainerClient storageContainerA = CreateStorageContainer(connectionStringA);
    BlobContainerClient storageContainerB = CreateStorageContainer(connectionStringB);

    Console.WriteLine("Uploading blobs to container A..");
    await UploadBlobsToContainerAsync(storageContainerA);

    Console.WriteLine("Copying blob to container B..");
    await CopyBlobsAsync(storageContainerA, storageContainerB);

    Console.WriteLine("Done!");
}

static BlobContainerClient CreateStorageContainer(string connectionString)
{
    string containerName = $"blobstoragecontainer-{Guid.NewGuid()}";
    BlobServiceClient client = new BlobServiceClient(connectionString);
    BlobContainerClient storageContainer = client.CreateBlobContainer(containerName);

    return storageContainer;
}

static async Task UploadBlobsToContainerAsync(BlobContainerClient storageContainerA)
{
    var tasks = Enumerable.Range(1, 100).Select((i) =>
    {
        BlobClient blobClient = storageContainerA.GetBlobClient($"Blob{i}");
        return blobClient.UploadAsync(BinaryData.FromString($"Hello! I'm Blob #{i}!"), true);
    });

    await Task.WhenAll(tasks).ContinueWith((b) => Console.WriteLine("Done!"));
}

async Task CopyBlobsAsync(BlobContainerClient copyFrom, BlobContainerClient copyTo)
{

    await foreach (BlobItem blobItem in copyFrom.GetBlobsAsync())
    {
        BlobClient fromClient = copyFrom.GetBlobClient(blobItem.Name);
        BlobClient toClient = copyTo.GetBlobClient(blobItem.Name);

        BlobSasBuilder builder = new(BlobContainerSasPermissions.Read, System.DateTimeOffset.UtcNow.AddHours(0.5));
        await toClient.StartCopyFromUriAsync(fromClient.GenerateSasUri(builder));
    }
}

