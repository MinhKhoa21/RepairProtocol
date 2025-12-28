extends Control

@onready var button_container = $HBoxContainer/Sidebar/VBoxContainer

@onready var subject_label = $HBoxContainer/VBoxContainer/Label
@onready var mail_content = $HBoxContainer/VBoxContainer/RichTextLabel

var mails = {
	"James Carter": {
		"subject": "Recon Report",
		"body": "Area secure. No hostiles found in sector 7."
	},
	"Commander": {
		"subject": "URGENT ORDER",
		"body": "Why are you gei?"
	},
	"Maria": {
		"subject": "Lunch?",
		"body": "Missubibi.Meet me at the cafeteria at 12:00."
	}
}

func _ready():
	for child in button_container.get_children():
		child.queue_free()
	
	for sender in mails:
		var btn = Button.new()
		btn.text = sender
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.pressed.connect(_on_mail_click.bind(sender))
		button_container.add_child(btn)
	
	# Load thư đầu tiên
	if mails.size() > 0:
		_on_mail_click(mails.keys()[0])

func _on_mail_click(sender):
	var data = mails[sender]
	
	subject_label.text = "Subject: " + data["subject"]
	
	mail_content.text = "From: " + sender + "\n\n" + data["body"]
