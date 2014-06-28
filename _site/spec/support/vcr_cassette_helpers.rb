# Returns VCR options specifying the path to the given cassette, found in a
# directory for the current context/describe block.
def relative_cassette cassette_name
  context = get_rspec_context(metadata)
  # 'FileSync_Saperion_DocumentService/valid_document_ID'
  path_to_cassette = context.map {|name| name.gsub(/::/, '_').gsub(/\s/, '_') }.
                             join('/')
  {cassette_name: path_to_cassette + '/' + cassette_name}
end

# e.g., ["FileSync::Saperion::DocumentService", "valid document ID"]
def get_rspec_context metadata, context=[]
  if metadata.has_key?(:example_group)
    get_rspec_context metadata[:example_group], context
  end
  context << metadata[:description_args]
  context.reject(&:blank?).map {|args| args.first.to_s }
end
