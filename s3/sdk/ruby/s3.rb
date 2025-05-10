# require 'aws-sdk-s3'
# require 'pry'
# require 'securerandom'

# bucket_name = ENV['BUCKET_NAME']
# region: "eu-west-2"

# Client = AWS:S3:Client.new

# resp = Client.create_bucket({
#     bucket: bucket_name,
#     create_bucket_configuration: {
#         location_constraint: region
#     }
# })

# number_of_files = 1+ rand(6)
# puts "number_of_files: #{number_of_files}"

# number_of_files.times.each do |i|
#     puts "i: #{i}"
#     filename = "file_#{i}.txt"
#     output_path = "/tmp/#{filename}"

#     File.open(output_path, "w") do |f|
#         f.write SecureRandom.uuid
#     end

#     File.open(output_path, 'rb') do |f|
#         s3.put_object(
#             bucket: bucket_name,
#             key: filename,
#             body: f
#         )
#     end
# end


# Load required libraries
require 'aws-sdk-s3'     # AWS SDK for interacting with S3
require 'pry'            # For debugging
require 'securerandom'   # To generate random UUIDs

# Get bucket name from environment variable
bucket_name = ENV['BUCKET_NAME']

# Set AWS region (corrected syntax to assignment)
region = 'eu-west-2'

# Initialize the S3 client (corrected module syntax)
client = Aws::S3::Client.new(region: region)

# Create an S3 bucket (handles location constraint for non-default regions)
# This may raise an error if the bucket already exists or is owned by someone else
begin
  resp = client.create_bucket({
    bucket: bucket_name,
    create_bucket_configuration: {
      location_constraint: region
    }
  })
  binding.pry
rescue Aws::S3::Errors::BucketAlreadyOwnedByYou
  puts "Bucket already exists and is owned by you."
end

# Create an S3 resource wrapper for easier object operations
s3 = Aws::S3::Resource.new(client: client)

# Generate a random number of files (1 to 6)
number_of_files = 1 + rand(6)
puts "number_of_files: #{number_of_files}"

# Loop to create and upload files
number_of_files.times do |i|
  puts "i: #{i}"
  filename = "file_#{i}.txt"
  output_path = "/tmp/#{filename}"  # Local temp file path

  # Write a random UUID string to the file
  File.open(output_path, "w") do |f|
    f.write SecureRandom.uuid
  end

  # Upload the file to S3
  File.open(output_path, 'rb') do |f|
    s3.bucket(bucket_name).object(filename).put(body: f)
  end
end