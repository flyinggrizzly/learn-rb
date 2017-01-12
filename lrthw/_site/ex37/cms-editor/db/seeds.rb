# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Build team
users = User.create([
  { username: 'mnskchg', display_name: 'Kelvin Gan', first_name: 'Kelvin', last_name: 'Gan', person_id: 173_030 },
  { username: 'pgw22', display_name: 'Philip Wilson', first_name: 'Philip', last_name: 'Wilson', person_id: 819_130 },
  { username: 'ma1twn', display_name: 'Tom Natt', first_name: 'Thomas', last_name: 'Natt', person_id: 139_897 },
  { username: 'tt227', display_name: 'Tom Trentham', first_name: 'Thomas', last_name: 'Trentham', person_id: 503_925 },
  { username: 'dsd28', display_name: 'Dan Dineen', first_name: 'Dan', last_name: 'Dineen', person_id: 1_125_235 },
  { username: 'lm317', display_name: 'Liam McMurray', first_name: 'Liam', last_name: 'McMurray', person_id: 927_388 }
])

# Organisations
Organisation.create(name: 'University of Bath', org_users: users)

Organisation.create(
  [
    { name: 'Academic Skills Centre' },
    { name: 'Accommodation, Eateries, Events & Security' },
    { name: 'Bath Institute for Mathematical Innovation' },
    { name: 'Campus Retail & Commercial Operations' },
    { name: 'Careers Service' },
    { name: 'Chaplaincy' },
    { name: 'Computing Services' },
    { name: 'Dental Centre' },
    { name: 'Department of Architecture & Civil Engineering' },
    { name: 'Department of Biology & Biochemistry' },
    { name: 'Department of Chemical Engineering' },
    { name: 'Department of Chemistry' },
    { name: 'Department of Computer Science' },
    { name: 'Department of Economics' },
    { name: 'Department of Education' },
    { name: 'Department of Electronic & Electrical Engineering' },
    { name: 'Department for Health' },
    { name: 'Department of Mathematical Sciences' },
    { name: 'Department of Mechanical Engineering' },
    { name: 'Department of Pharmacy & Pharmacology' },
    { name: 'Department of Physics' },
    { name: 'Department of Politics, Languages & International Studies' },
    { name: 'Department of Psychology' },
    { name: 'Department of Social & Policy Sciences' },
    { name: 'Development & Alumni Relations' },
    { name: 'Estates' },
    { name: 'Esther Parkin Trust' },
    { name: 'Faculty of Engineering & Design' },
    { name: 'Faculty of Humanities & Social Sciences' },
    { name: 'Faculty of Science' },
    { name: 'Finance & Procurement' },
    { name: 'Human Resources' },
    { name: 'Institute for Policy Research' },
    { name: 'International Relations Office' },
    { name: 'Learning & Teaching Enhancement' },
    { name: 'Library' },
    { name: 'Marketing & Communications' },
    { name: 'Office of Policy & Planning' },
    { name: 'Office of the University Secretary' },
    { name: 'Research & Innovation Services' },
    { name: 'School of Management' },
    { name: 'Student Records & Examinations Office' },
    { name: 'Student Recruitment & Admissions' },
    { name: 'Student Services' },
    { name: "Students' Union" },
    { name: 'Team Bath' },
    { name: "Vice-Chancellor's Office" }
  ]
)

# Groups
aess = Organisation.find_by_name('Accommodation, Eateries, Events & Security')
Group.create(name: 'Conferences & Events',  organisation: aess)
Group.create(name: 'Eateries',              organisation: aess)
Group.create(name: 'Security',              organisation: aess)
Group.create(name: 'Student Accommodation', organisation: aess)

fed = Organisation.find_by_name('Faculty of Engineering & Design')
Group.create(name: 'Faculty of Engineering & Design Board of Studies',                    organisation: fed)
Group.create(name: 'Faculty of Engineering & Design Graduate School',                     organisation: fed)
Group.create(name: 'Faculty of Engineering & Design Graduate School Committee',           organisation: fed)
Group.create(name: 'Engineering & Design Faculty Executive Committee',                    organisation: fed)
Group.create(name: 'Engineering & Design Faculty Learning, Teaching & Quality Committee', organisation: fed)
Group.create(name: 'Engineering & Design Faculty Research Committee',                     organisation: fed)
Group.create(name: "Engineering & Design Faculty Research Students' Committee",           organisation: fed)

hss = Organisation.find_by_name('Faculty of Humanities & Social Sciences')
Group.create(name: 'Faculty of Humanities & Social Sciences Graduate School', organisation: hss)

fos = Organisation.find_by_name('Faculty of Science')
Group.create(name: 'Faculty of Science Graduate School', organisation: fos)
Group.create(name: 'Intelligent Systems',                organisation: fos)
Group.create(name: 'Media Technology Research Centre',   organisation: fos)
Group.create(name: 'The Milner Centre for Evolution',    organisation: fos)

ss = Organisation.find_by_name('Student Services')
Group.create(name: 'Counselling & Mental Health ', organisation: ss)
Group.create(name: 'The Disability Service',       organisation: ss)
Group.create(name: 'International Student Advice', organisation: ss)
Group.create(name: 'Student Money Advice',         organisation: ss)
