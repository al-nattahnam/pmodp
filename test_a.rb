require './sample_application'

app = Application.new("A", ["received"], true, false)
app.setup
app.run
