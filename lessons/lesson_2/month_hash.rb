months = { january: 31,
           february: 28,
           march: 31,
           april: 30,
           may: 31,
           june: 30,
           july: 31,
           august: 31,
           september: 30,
           october: 31,
           november: 30,
           december: 31
}

days30_months = months.select { |_, days| days == 30 }

print 'Months with 30 days are: '
days30_months.each_key { |month| print "#{month} " }
