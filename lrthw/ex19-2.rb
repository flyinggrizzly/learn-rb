# study drill 3, own function run in 10 days

def foo(arg1, arg2)
  puts arg1 - arg2
end

foo(1, 1)

bar = 2
baz = 100

foo(bar, baz)

foo(bar = 3, baz)

# now that I've reassigned bar, is that scoped to the above call?
## no, it's not
foo(bar, baz)

print "I would like ", foo(baz, bar), " apples"
