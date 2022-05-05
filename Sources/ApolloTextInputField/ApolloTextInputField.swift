//
//  LAWTextField.swift
//  LawInputTextField
//
//  Created by Amjad Khan on 16/04/19.
//  Copyright © 2019 Conduent. All rights reserved.
//

import UIKit

public enum  datePickerType {
    case automatic
    case wheels
    case compact
    case inline
}

@IBDesignable public class ApolloTextInputField: UIView {
    
    @IBOutlet weak internal var titleLabelTextFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak internal var textFieldHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak internal var textViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak internal var textField: CustomTextField!
    @IBOutlet weak internal var textView: UITextView!
    @IBOutlet weak public var sepratorView: UIView!
    @IBOutlet weak public var titleLabel: UILabel!
    @IBOutlet weak public var errorLabel: UILabel!
    @IBOutlet weak public var clearButton: UIButton!
    @IBOutlet weak var clearButtonRightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var lineSeparatorTopConstraint: NSLayoutConstraint!
    let defaultTextViewHeight: CGFloat = 30
    
    internal var lineFocusColor: UIColor = UIColor.LineColor.Focus       // Black Color
    internal var lineActiveColor: UIColor = UIColor.LineColor.Active     // Orange Color
    internal var lineSuccessColor: UIColor = UIColor.LineColor.Success   // Green Color
    internal var lineFailiureColor: UIColor = UIColor.LineColor.Failure  // Red Color
    internal var lineWarningColor: UIColor = UIColor.LineColor.Warning   // Yellow Color
    internal var lineDefaultColor: UIColor = UIColor.LineColor.Default   // Gray Color
    internal var lineDisableColor: UIColor = UIColor.LineColor.Disable   // light Gray Color
    
    internal var errorTextValue: String?
    internal var errorColorValue: UIColor?
    internal var errorFontValue: UIFont?
    internal var successTextValue: String?
    internal var successColorValue: UIColor?
    internal var successFontValue: UIFont?
    internal var warningTextValue: String?
    internal var warningColorValue: UIColor?
    internal var warningFontValue: UIFont?
    internal var placeholderTextColor: UIColor = UIColor.LineColor.Default
    internal var dateAndTimeFieldTapGesture:UITapGestureRecognizer?
    internal var isDateTimeFieldEditable:Bool =  true
    internal var isTextFieldEditable:Bool =  true
    internal var timeStyle:DateFormatter.Style = .short
    open var pickerType: datePickerType = .automatic
    
    public var contentType: UITextContentType?
    //MARK: - Date var
    open var maxDate: Date?
    open var minDate: Date?
    public var doneBtnLocalizedName = "Done"
    public var cancelBtnLocalizedName = "Cancel"
    
    public weak var delegate: ApolloTextInputFieldDelegate?
    let bundle = Bundle(for: ApolloTextInputField.self)
    
    /**
     A character which will be replaced in formattingPattern by a number
     */
    public var replacementChar: Character = "*"
    
    /**
     A character which will be replaced in formattingPattern by a number
     */
    public var secureTextReplacementChar: Character = "\u{25cf}"
    
    /**
     Max length of input string. You don't have to set this if you set formattingPattern.
     If 0 -> no limit.
     */
    public var maxLength = 0
    
    public var isCustomFormat = false
    
    /**
     String with formatting pattern for the text field.
     */
    public var formattingPattern: String = "" {
        didSet {
            self.maxLength = formattingPattern.count
        }
    }
    
    // MARK: - INTERNAL
    internal var _formatedSecureTextEntry = false
    
    
    // if secureTextEntry is false, this value is similar to self.text
    // if secureTextEntry is true, you can find final formatted text without bullets here
    internal var _textWithoutSecureBullets = ""
    
    /**
     Provides secure text entry but KEEPS formatting. All digits are replaced with the bullet character \u{25cf} .
     */
    public var formatedSecureTextEntry: Bool {
        set {
            _formatedSecureTextEntry = newValue
            textField.isSecureTextEntry = false
        }
        
        get {
            return _formatedSecureTextEntry
        }
    }
    // MARK: Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        _ = fromNib()
        setupTextField()
        setupTextView()
        showTextView(false)
        setupTitle()
        setupClearButton()
        setupErrorTitle()
    }
    
    public var validationType: LAWTextFieldValidationType = .none {
        didSet {
            switch validationType {
            case LAWTextFieldValidationType.multiline:
                showTextView(true)
                addTextViewPlaceholder()
                self.textFieldHeightConstraint.isActive = false
                break
            case  .ssn, .password, .date, .dropdown, .time:
                showTextView(false)
                self.textFieldHeightConstraint.isActive = true
                showClearButton(false)
                self.clearButton.isHidden = false
                
                if(validationType == .date){
                    setupClearButtonImage(withImage: "calendar_ic")
                    self.keyboardType = UIKeyboardType.numberPad.rawValue
                }
                else  if(validationType == .time){
                    setupClearButtonImage(withImage: "time_ic")
                    self.keyboardType = UIKeyboardType.numberPad.rawValue
                }
                else if (validationType == .dropdown) {
                    textField.isUserInteractionEnabled = false
                    setupClearButtonImage(withImage: "right_caret_icon")
                    self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapOnLawTextField)))
                }
                else if(validationType == .ssn) {
                    self.keyboardType = UIKeyboardType.numberPad.rawValue
                }
                else {
                    setupClearButtonImage(withImage: "eyeball_cross_ic")
                }
                break
            default:
                showTextView(false)
                self.textFieldHeightConstraint.isActive = true
                break
            }
        }
    }
    /**
     Set a formatting pattern for a number and define a replacement string. For example: If formattingPattern would be "##-##-##-##" and
     replacement string would be "#" and user input would be "123456", final string would look like "12-34-56-78"
     */
    public func setFormatting(formattingPattern: String, replacementChar: Character) {
        self.formattingPattern = formattingPattern
        self.replacementChar = replacementChar
        self.isCustomFormat = true
    }
    // MARK : To set the current focus to control
    public func setFocus() {
        if (validationType == .multiline) {
            textView.becomeFirstResponder()
        }
        else {
            self.sepratorView.backgroundColor = self.lineActiveColor
            textField.becomeFirstResponder()
        }
    }
    // MARK : To set the dismiss focus to control
    public func dismissFocus() {
        if (validationType == .multiline) {
            textView.resignFirstResponder()
        }
        else {
            textField.inputView = nil
            textField.resignFirstResponder()
        }
    }
    
    //MARK : To Set the text and placeholder without showing focus and clear image
    public func setText(text: String) {
        animateInWithText(text: text)
    }
    // MARK : To set the font for Title
    public func setTitleFont(font:UIFont?){
        if let font = font {
            titleLabel.font = font
        }
    }
    
    // To give height between "Textfield" and Separator
    public func setSeparatorTopConstraint(_ value:CGFloat)
    {
        lineSeparatorTopConstraint.constant = value
    }
    // To give height between "Title" and textfield
    public func setTextFieldTopConstraint(_ value:CGFloat)
    {
        titleLabelTextFieldConstraint.constant = value
    }
    
    // This method is used to disable/ enable the textfield with disable color
    public func setTextFieldIsEditable(_ isEditable:Bool){
        textField.isUserInteractionEnabled = isEditable
        textView.isUserInteractionEnabled = isEditable
        isTextFieldEditable = isEditable
        self.clearButton.isUserInteractionEnabled = isEditable
        if isEditable {
            titleLabel.textColor = lineDefaultColor
            textField.textColor = textColor
            textView.textColor = textColor
            if !(self.textField.text?.isEmpty ?? true) || !(self.textView.text?.isEmpty ?? true) {
                sepratorView.backgroundColor = separatorFilledColor
            } else{
                sepratorView.backgroundColor = separatorDefaultColor
            }
        }
        else{
            titleLabel.textColor = lineDisableColor
            textField.textColor = lineDisableColor
            textView.textColor = lineDisableColor
            sepratorView.backgroundColor = lineDisableColor
            if  let image = self.clearButton.image(for: .normal) {
                self.clearButton.setImage(image.withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
                self.clearButton.tintColor = lineDisableColor
            }
        }
    }
    public func setDateAndTimeFieldEditable(_ isEditable:Bool) {
        
        self.isDateTimeFieldEditable = isEditable
        
        if let tapGesture = dateAndTimeFieldTapGesture {
            self.removeGestureRecognizer(tapGesture)
        }
        self.textField.isUserInteractionEnabled = isEditable
        if !isEditable {
            dateAndTimeFieldTapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnDateAndTimeTextField))
            self.addGestureRecognizer(dateAndTimeFieldTapGesture!)
        }
    }
    
    
    // MARK: Inspectable properties
    
    @IBInspectable public var titleColor: UIColor = UIColor.LineColor.Default {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    @IBInspectable public var titleSize: CGFloat = 12.0 {
        didSet {
            titleLabel.font = UIFont.systemFont(ofSize: titleSize)
        }
    }
    
    @IBInspectable public var placeholder: String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
            guard let placeholderText = newValue else { return }
            self.setupPlaceholderColor(text: placeholderText)
            self.setupAccessibility()
        }
    }
    
    @IBInspectable
    public var placeholderColor: UIColor = UIColor.LineColor.Default {
        didSet {
            placeholderTextColor = placeholderColor
            if let placeholderText = placeholder {
                self.setupPlaceholderColor(text: placeholderText)
            }
        }
    }
    
    @IBInspectable
    public var text: String? {
        get {
            if self.validationType == .multiline {
                return textView.text
            } else {
                return textField.text
            }
        }
        set {
            if self.validationType == .multiline {
                textView.text = newValue
            } else {
                textField.text = newValue
            }
        }
    }
    
    @IBInspectable
    public var textFont: UIFont = UIFont.systemFont(ofSize:18) {
        didSet {
            textField.font = textFont
            textView.font =  textFont
        }
    }
    @IBInspectable
    public var textSize: CGFloat = 18.0 {
        didSet {
            textField.font = UIFont.systemFont(ofSize: textSize)
            textView.font =  UIFont.systemFont(ofSize: textSize)
        }
    }
    @IBInspectable
    public var textColor: UIColor = UIColor.black {
        didSet {
            textField.textColor = textColor
        }
    }
    
    @IBInspectable
    public var errorText: String? {
        get {
            return errorTextValue
        }
        set {
            errorTextValue = newValue
        }
    }
    
    @IBInspectable
    public var errorTextSize: CGFloat = 13.0 {
        didSet {
            errorFontValue = UIFont.systemFont(ofSize: errorTextSize)
        }
    }
    
    @IBInspectable
    public var errorTextColor: UIColor = UIColor.red {
        didSet {
            errorColorValue = errorTextColor
        }
    }
    
    @IBInspectable
    public var successText: String? {
        get {
            return successTextValue
        }
        set {
            successTextValue = newValue
        }
    }
    
    @IBInspectable
    public var successTextSize: CGFloat = 13.0 {
        didSet {
            successFontValue = UIFont.systemFont(ofSize: successTextSize)
        }
    }
    
    @IBInspectable
    public var successTextColor: UIColor = UIColor.LineColor.Success {
        didSet {
            successColorValue = successTextColor
        }
    }
    
    @IBInspectable
    public var warningText: String? {
        get {
            return warningTextValue
        }
        set {
            warningTextValue = newValue
        }
    }
    
    @IBInspectable
    public var warningTextSize: CGFloat = 13.0 {
        didSet {
            warningFontValue = UIFont.systemFont(ofSize: successTextSize)
        }
    }
    
    @IBInspectable
    public var warningTextColor: UIColor = UIColor.yellow {
        didSet {
            warningColorValue = successTextColor
        }
    }
    
    @IBInspectable
    public var separatorDefaultColor: UIColor = UIColor.LineColor.Default {
        didSet {
            lineDefaultColor = separatorDefaultColor
            sepratorView.backgroundColor = lineDefaultColor
        }
    }
    
    @IBInspectable
    public var separatorFocusColor: UIColor = UIColor.LineColor.Focus {
        didSet {
            lineFocusColor = separatorFocusColor
        }
    }
    
    @IBInspectable
    public var separatorFilledColor: UIColor = UIColor.LineColor.Active {
        didSet {
            lineActiveColor = separatorFilledColor
        }
    }
    
    @IBInspectable
    public var separatorWarningColor: UIColor = UIColor.LineColor.Warning {
        didSet {
            lineWarningColor = separatorWarningColor
        }
    }
    
    @IBInspectable
    public var secureTextEntry: Bool = false {
        didSet {
            textField.isSecureTextEntry = secureTextEntry
        }
    }
    @IBInspectable
       public var disableSelectedTextRange: Bool = false {
           didSet {
                textField.selectedTextRange = disableSelectedTextRange == true ? nil : textField.selectedTextRange
           }
       }
    @IBInspectable
    public var autocorrectionType: UITextAutocorrectionType = .default {
        didSet {
            textField.autocorrectionType = autocorrectionType
        }
    }
    
    @IBInspectable
    public var keyboardType: Int = 0 {
        didSet {
            /*
             0: default // Default type for the current input method.
             1: asciiCapable // Displays a keyboard which can enter ASCII characters
             2: numbersAndPunctuation // Numbers and assorted punctuation.
             3: URL // A type optimized for URL entry
             4: numberPad // A number pad with locale-appropriate digits. Suitable for PIN entry.
             5: phonePad // A phone pad (1-9, *, 0, #, with letters under the numbers).
             6: namePhonePad // A type optimized for entering a person's name or phone number.
             7: emailAddress // A type optimized for multiple email address entry.
             8: decimalPad // A number pad with a decimal point.
             9: twitter // A type optimized for twitter text entry (easy access to @ #)
             */
            self.textField.keyboardType = UIKeyboardType.init(rawValue: keyboardType)!
            if(self.textField.keyboardType == .numberPad){
                addDoneButtonOnKeyboard()
            }
            else {
                
            }
        }
    }
    
    @IBInspectable
    public var capitalisation: Int {
        get {
            return textField.autocapitalizationType.rawValue
        }
        set {
            /*
             0: case none
             1: case words
             2: case sentences
             3: case allCharacters
             */
            self.textField.autocapitalizationType = UITextAutocapitalizationType.init(rawValue: newValue)!
        }
    }
    
    @IBInspectable
    public var returnKeyType: UIReturnKeyType = .default {
        didSet {
            if self.validationType == .multiline {
                textView.returnKeyType = returnKeyType
            }
            else {
                textField.returnKeyType = returnKeyType
            }
        }
    }
    
    @IBInspectable
    public var clearButtonRightConstraintConstant: CGFloat = 8.0 {
        didSet {
            self.clearButtonRightConstraint.constant =  clearButtonRightConstraintConstant
        }
    }
   
    
    
    // MARK: private/internal methods
    
    private func setupTextField() {
        textField.placeholder = placeholder
        textField.tintColor = UIColor.black
        textField.textColor = textColor
        textField.delegate = self
        textField.tag = tag
        textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        if let contentType = contentType {
            if #available(iOS 10.0, *) {
                textField.textContentType = contentType
            } else {
                // Fallback on earlier versions
            }
        }
        
    }
    private func addDoneButtonOnKeyboard(){
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: doneBtnLocalizedName, style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        textField.inputAccessoryView = doneToolbar
        textField.inputView = nil
        textField.reloadInputViews()
    }
    
    @objc private func doneButtonAction(){
        checkValidation()
        textField.resignFirstResponder()
        
    }
    
    private func setupTitle() {
        titleLabel.alpha = 0.0
        titleLabel.text = placeholder
    }
    
    private func setupErrorTitle() {
        errorLabel.alpha = 0.0
    }
    
    func setupPlaceholderColor(text: String) {
        textField.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: placeholderTextColor])
    }
    
    
    //
    // MARK: TextView Methods
    
    private func setupTextView() {
        textView.delegate = self
        textView.tag = tag
        textView.isScrollEnabled = false
        textView.tintColor = UIColor.black
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
    }
    
    internal func addTextViewPlaceholder() {
        if textView.text == "" {
            textView.text = placeholder
            textView.textColor = placeholderColor
        }
    }
    
    internal func removeTextViewPlaceholder() {
        if textView.text == placeholder {
            self.textView.text = ""
            self.textView.textColor = UIColor.black
        }
    }
    
    private func showTextView(_ show: Bool) {
        textField.isHidden = show
        textView.text = show ? nil : ""
        textView.isHidden = !show
    }
    
    internal func resizeTextViewHeight() {
        let size = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
        var updatedHeight = size.height
        if (updatedHeight > defaultTextViewHeight) { updatedHeight += 4 } else {  updatedHeight = defaultTextViewHeight }
        self.textViewHeightConstraint.constant = updatedHeight
        self.layoutIfNeeded()
        
        delegate?.resizeTextField(self, didResizeHeight: size.height + 30)
    }
    
    private func setupClearButton() {
        let clearImage = UIImage(named: "clear_ic", in: bundle, compatibleWith: nil)
        self.clearButton.setImage(clearImage, for: .normal)
        self.clearButton.isHidden = true
    }
    
    public func setupClearButtonImage(withImage imageName: String) {
        let clearImage = UIImage(named: imageName, in: bundle, compatibleWith: nil)
        self.clearButton.setImage(clearImage, for: .normal)
    }
    
    @IBAction private func clearButtonPressed(sender: AnyObject) {
        if (validationType == .password || validationType == .ssn || validationType == .date || validationType == .time || validationType == .dropdown) {
            
            switch validationType {
            case .date:
                textField.endEditing(true)
                showPicker(with: .date)
            case .time:
                textField.endEditing(true)
                showPicker(with: .time)
            case .dropdown:
                self.didTapOnLawTextField()
            default:
                togglePasswordVisibility()
            }
            
        }
        else if clearButton.currentImage == UIImage(named: "clear_ic", in: bundle, compatibleWith: nil)! {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0, animations: {
                    self.textView.text = ""
                    self.textField.text = ""
                    self.errorLabel.alpha = 0.0
                }) { (_) in
                    self.animateOut()
                    self.resizeTextViewHeight()
                    self.addTextViewPlaceholder()
                }
            }
        }
    }
    //MARK: function to convert the string in required format
    @objc func textFieldDidChange(_ textField: UITextField) {
        delegate?.lawTextFieldDidChange(textField: self)
        guard isCustomFormat == true else {
            return
        }
        var superText: String { return textField.text ?? "" }
        
        // TODO: - Isn't there more elegant way how to do this?
        let currentTextForFormatting: String
        
        if superText.count > _textWithoutSecureBullets.count {
            currentTextForFormatting = _textWithoutSecureBullets + superText[superText.index(superText.startIndex, offsetBy: _textWithoutSecureBullets.count)...]
        } else if superText.count == 0 {
            _textWithoutSecureBullets = ""
            currentTextForFormatting = ""
        } else {
            currentTextForFormatting = String(_textWithoutSecureBullets[..<_textWithoutSecureBullets.index(_textWithoutSecureBullets.startIndex, offsetBy: superText.count)])
        }
        
        if currentTextForFormatting.count > 0 && formattingPattern.count > 0 {
            let tempString = currentTextForFormatting.keepOnlyDigits()
            
            var finalText = ""
            var finalSecureText = ""
            
            var stop = false
            
            var formatterIndex = formattingPattern.startIndex
            var tempIndex = tempString.startIndex
            
            while !stop {
                let formattingPatternRange = formatterIndex ..< formattingPattern.index(formatterIndex, offsetBy: 1)
                if formattingPattern[formattingPatternRange] != String(replacementChar) {
                    
                    finalText = finalText + formattingPattern[formattingPatternRange]
                    finalSecureText = finalSecureText + formattingPattern[formattingPatternRange]
                    
                } else if tempString.count > 0 {
                    
                    let pureStringRange = tempIndex ..< tempString.index(tempIndex, offsetBy: 1)
                    
                    finalText = finalText + tempString[pureStringRange]
                    
                    // we want the last number to be visible
                    if tempString.index(tempIndex, offsetBy: 1) == tempString.endIndex {
                        finalSecureText = finalSecureText + tempString[pureStringRange]
                    } else {
                        finalSecureText = finalSecureText + String(secureTextReplacementChar)
                    }
                    
                    tempIndex = tempString.index(after: tempIndex)
                }
                
                formatterIndex = formattingPattern.index(after: formatterIndex)
                
                if formatterIndex >= formattingPattern.endIndex || tempIndex >= tempString.endIndex {
                    stop = true
                }
            }
            
            _textWithoutSecureBullets = finalText
            
            let newText = _formatedSecureTextEntry ? finalSecureText : finalText
            if newText != superText {
                textField.text = _formatedSecureTextEntry ? finalSecureText : finalText
            }
        }
        
        // Let's check if we have additional max length restrictions
        if maxLength > 0 {
            if superText.count > maxLength {
                textField.text = String(superText[..<superText.index(superText.startIndex, offsetBy: maxLength)])
                _textWithoutSecureBullets = String(_textWithoutSecureBullets[..<_textWithoutSecureBullets.index(_textWithoutSecureBullets.startIndex, offsetBy: maxLength)])
            }
        }
    }
    
    //MARK: function to toggle the eye Open/Close image for Password input
    internal func togglePasswordVisibility() {
        if (textField.isSecureTextEntry) {
            textField.isSecureTextEntry = false
            setupClearButtonImage(withImage: "eyeball_ic")
        }
        else {
            textField.isSecureTextEntry = true
            setupClearButtonImage(withImage: "eyeball_cross_ic")
        }
    }
    
    public func setTimeStyle(style:DateFormatter.Style){
        self.timeStyle = style
    }
    
    
    //MARK: - Show Date Picker with Toolbar Done and cancel icon
    internal func showPicker(with validationType: LAWTextFieldValidationType) {
        
        if textField.inputView == nil {
            // has to set isUserInteractionEnabled is true to show picker on click
            self.textField.isUserInteractionEnabled = true
            //ToolBar
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            var doneButton = UIBarButtonItem()
            let datePicker = UIDatePicker()
            if validationType == .date {
                datePicker.datePickerMode = .date
                if #available(iOS 13.4, *) {
                    switch pickerType {
                    case .wheels :
                        datePicker.preferredDatePickerStyle = .wheels
                    case .compact :
                        datePicker.preferredDatePickerStyle = .compact
                    case .inline :
                        if #available(iOS 14.0, *) {
                            datePicker.preferredDatePickerStyle = .inline
                        } else {
                            // Fallback on earlier versions
                        }
                    default:
                        datePicker.preferredDatePickerStyle = .automatic
                    }
                    
                } else {
                    // Fallback on earlier versions
                }
                datePicker.maximumDate = maxDate
                datePicker.minimumDate = minDate
                if let strDate = textField.text, !strDate.isEmpty {
                    datePicker.setDate(Date.dateFormatter.date(from: strDate) ?? Date(), animated: true)
                } else if let minDate = self.minDate {
                    datePicker.setDate(minDate, animated: true)
                }
                doneButton = UIBarButtonItem(title: doneBtnLocalizedName, style: .plain, target: self, action: #selector(doneDatePicker))
            } else {
                datePicker.datePickerMode = .time
                if #available(iOS 13.4, *) {
                    switch pickerType {
                    case .wheels :
                        datePicker.preferredDatePickerStyle = .wheels
                    case .compact :
                        datePicker.preferredDatePickerStyle = .compact
                    case .inline :
                        if #available(iOS 14.0, *) {
                            datePicker.preferredDatePickerStyle = .inline
                        } else {
                            // Fallback on earlier versions
                        }
                    default:
                        datePicker.preferredDatePickerStyle = .automatic
                    }
                    
                } else {
                    // Fallback on earlier versions
                }
                if let strTime = textField.text ,!strTime.isEmpty {
                    datePicker.setDate(Date.timeFormatter.date(from: strTime) ?? Date(), animated: true)
                }
                
                doneButton = UIBarButtonItem(title: doneBtnLocalizedName, style: .plain, target: self, action: #selector(doneTimePicker))
            }
            
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: cancelBtnLocalizedName, style: .plain, target: self, action: #selector(cancelDatePicker));
            toolbar.setItems([cancelButton,spaceButton,doneButton], animated: false)
            textField.inputAccessoryView = toolbar
            textField.inputView = datePicker
            DispatchQueue.main.async {
                self.sepratorView.backgroundColor = self.lineActiveColor
                self.errorLabel.alpha = 0.0
                self.setFocus()
            }
        }
        else {
            self.cancelDatePicker()
        }
    }
    
    @objc func doneDatePicker(){
        
        if let datePicker = textField.inputView as? UIDatePicker {
            textField.text = Date.dateFormatter.string(from: datePicker.date)
            
        }
        textField.resignFirstResponder()
        keyboardType = UIKeyboardType.numberPad.rawValue
        checkValidation()
        if self.isDateTimeFieldEditable == false{
            self.textField.isUserInteractionEnabled = false
        }
    }
    
    @objc func doneTimePicker() {
        let formatter = Date.timeFormatter
        formatter.timeStyle = timeStyle
        if let timePicker = textField.inputView as? UIDatePicker {
            textField.text = formatter.string(from: timePicker.date)
        }
        textField.resignFirstResponder()
        keyboardType = UIKeyboardType.numberPad.rawValue
        if self.isDateTimeFieldEditable == false{
            self.textField.isUserInteractionEnabled = false
        }
        delegate?.timeFieldDoneClicked(self)
    }
    
    @objc func cancelDatePicker() {
        textField.resignFirstResponder()
        keyboardType = UIKeyboardType.numberPad.rawValue
        
        if self.isDateTimeFieldEditable == false{
            self.textField.isUserInteractionEnabled = false
        }
        
    }
    private func checkValidation() {
        delegate?.dateFieldDoneClicked(self)
    }
    @objc func didTapOnLawTextField() {
        if self.isTextFieldEditable{
            delegate?.lawTextFieldTapped(self)
        }
    }
    @objc func didTapOnDateAndTimeTextField() {
        if self.isTextFieldEditable {
            self.textField.isUserInteractionEnabled = true
            self.clearButtonPressed(sender: UIView())
        }
    }
    // MARK: This varibale is used to enable and disable the options on long press i;e cut, copy, select, select All .. etc
   public var isActionsEnabled = true {
           didSet {
            self.textField.enableLongPressActions = isActionsEnabled
            self.textField.reloadInputViews()
           }
       }
    
}

extension ApolloTextInputField {
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
}

class CustomTextField: UITextField {
    var enableLongPressActions = true
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if enableLongPressActions {
         return   super.canPerformAction(action, withSender: sender)
        }
        return enableLongPressActions
    }
}
