task index_jobs: :environment do
  if ENV['SWIFTYPE_API_KEY'].blank?
    abort("SWIFTYPE_API_KEY not set")
  end

  if ENV['SWIFTYPE_ENGINE_SLUG'].blank?
    abort("SWIFTYPE_ENGINE_SLUG not set")
  end

  client = Swiftype::Client.new

  Job.find_in_batches(batch_size: 100) do |jobs|
    documents = jobs.map do |job|
      url = Rails.application.routes.url_helpers.job_url(job)
      {external_id: job.id,
       fields: [{name: 'title', value: job.title, type: 'string'},
                   {name: 'job_type', value: job.job_type, type: 'string'},
                   {name: 'company_name', value: job.company_name, type: 'string'},
                   {name: 'salary', value: job.salary, type: 'string'},
                   {name: 'location', value: job.location, type: 'string'},
                   {name: 'email', value: job.email, type: 'string'},
                   {name: 'company_url', value: job.company_url, type: 'string'},
                   {name: 'description', value: job.description, type: 'text'},
                   {name: 'url', value: url, type: 'enum'},
                   {name: 'created_at', value: job.created_at.iso8601, type: 'date'}]}
    end

    results = client.create_or_update_documents(ENV['SWIFTYPE_ENGINE_SLUG'], Job.model_name.plural, documents)

    results.each_with_index do |result, index|
      puts "Could not create #{jobs[index].title} (##{jobs[index].id})" if result == false
    end
  end
end
