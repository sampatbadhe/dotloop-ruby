module Helpers
  def dotloop_mock(request, request_type = :get, status_code = 200, query_params = "")
    endpoint = standard_endpoints(request)
    data_file = File.new(filename_to_path_json(endpoint, request_type.to_s))
    WebMock
      .stub_request(request_type, endpoint_to_url(endpoint + query_params))
      .to_return(body: data_file, status: status_code, headers: { 'Content-Type' => 'application/json' })
  end

  def dotloop_mock_batch(request)
    endpoint = standard_endpoints(request)
    batch1_file = File.new(filename_to_path_json([endpoint, '_page1']))
    batch2_file = File.new(filename_to_path_json([endpoint, '_page1']))
    batch3_file = File.new(filename_to_path_json([endpoint, '_page2']))
    url = endpoint_to_url(endpoint)
    WebMock
      .stub_request(:get, [url, '?batch_number=1&batch_size=100'].join)
      .to_return(body: batch1_file, status: 200, headers: { 'Content-Type' => 'application/json' })
    WebMock
      .stub_request(:get, [url, '?batch_number=1&batch_size=50'].join)
      .to_return(body: batch2_file, status: 200, headers: { 'Content-Type' => 'application/json' })
    WebMock
      .stub_request(:get, [url, '?batch_number=2&batch_size=50'].join)
      .to_return(body: batch3_file, status: 200, headers: { 'Content-Type' => 'application/json' })
  end

  def dotloop_mock_raise_error(request, error, batch = false)
    endpoint = standard_endpoints(request)
    url = endpoint_to_url(endpoint)
    batch && url += '?batch_number=1&batch_size=50'
    WebMock
      .stub_request(:get, url)
      .to_raise(error)
  end

  def dotloop_pdf
    WebMock.stub_request(
      :get,
      endpoint_to_url(
        'profile/1234/loop/76046/folder/423424/document/561621'
      )
    ).to_return(body: disclosure_file_data,
                status: 200,
                headers: {
                  'Content-Type' => 'application/pdf',
                  'content-disposition' => ['attachment; filename="AgencyDisclosureStatementSeller.pdf"']
                })
  end

  private

  def disclosure_file_data
    File.read(
      filename_to_path(
        'profile/1234/loop/76046/folder/423424/document/561621/AgencyDisclosureStatementSeller.pdf',
        'get'
      ),
      encoding: Encoding::ASCII_8BIT
    )
  end

  def filename_to_path_json(filenames, request_type = 'get')
    filename_to_path([filenames].flatten.join.chomp("/") + '.json', request_type)
  end

  def filename_to_path(filename, request_type)
    dotloop_stub_path = ROOT.join('spec', 'stub_responses', request_type)
    File.new(dotloop_stub_path.join(filename))
  end

  def endpoint_to_url(endpoint)
    dotloop_url = 'https://api-gateway.dotloop.com/public/v2/'
    [dotloop_url, endpoint].join
  end

  def standard_endpoints(lookup)
    {
      loop_it:         'loop-it',
      profiles:        'profile',
      profile:         'profile/1234',
      loops:           'profile/1234/loop',
      loop:            'profile/1234/loop/76046',
      loop_detail:     'profile/1234/loop/76046/detail',
      folders:         'profile/1234/loop/76046/folder',
      folder:          'profile/1234/loop/76046/folder/423424',
      documents:       'profile/1234/loop/76046/folder/423424/document',
      document_upload: 'profile/1234/loop/76046/folder/423424/document/',
      document:        'profile/1234/loop/76046/folder/423424/document/561621',
      participants:    'profile/1234/loop/76046/participant',
      participant:     'profile/1234/loop/76046/participant/2355',
      tasklists:       'profile/1234/loop/76046/tasklist',
      tasklist:        'profile/1234/loop/76046/tasklist/123',
      tasks:           'profile/1234/loop/76046/tasklist/123/task',
      task:            'profile/1234/loop/76046/tasklist/123/task/125736485',
      loop_templates:  'profile/1234/loop-template',
      loop_template:   'profile/1234/loop-template/421',
      contacts:        'contact',
      contact:         'contact/3603862'
    }[lookup.to_sym]
  end
end
