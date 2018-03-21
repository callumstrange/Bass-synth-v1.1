//
//  ViewController.swift
//  Desktop synth
//
//  Created by callum strange on 17/03/2018.
//  Copyright © 2018 callum strange. All rights reserved.
//

import UIKit
import AudioKit
import AudioKitUI

class ViewController: UIViewController, AKKeyboardDelegate {
  
    var osc = AKMorphingOscillatorBank()
    var osc2 = AKMorphingOscillatorBank()

    var filter = AKRolandTB303Filter()
    
    var adsr = AKAmplitudeEnvelope()
    
    
    var mixer = AKMixer()
    
    var masterVolume = AKBooster()

    @IBOutlet weak var keyvie: UIStackView!
    
    @IBOutlet fileprivate weak var masterVolKnob: Knob!
    
    @IBOutlet weak var processone: Knob!
    
    @IBOutlet weak var processtwo: Knob!
    
    @IBOutlet weak var processthree: Knob!
    
    @IBOutlet weak var attack: Knob!
    
    @IBOutlet weak var decay: Knob!
    
    @IBOutlet weak var sustain: Knob!
    
    @IBOutlet weak var rellength: Knob!
    
    @IBOutlet weak var lforate: Knob!
    
    @IBOutlet weak var lfodep: Knob!
    
    @IBOutlet weak var ramptme: Knob!
    
    
    @IBOutlet weak var AudioPlot: EZAudioPlot!
    
let hz = 2.0
    
    func setupkeyb() {
        
        let Keyboard = AKKeyboardView(frame: keyvie.bounds)
        keyvie.addSubview(Keyboard)
        Keyboard.keyOnColor = UIColor.cyan
        Keyboard.whiteKeyOff = UIColor.darkGray
        Keyboard.firstOctave = 0
        Keyboard.polyphonicMode = true
        Keyboard.delegate = self
        }
    func setupPlot() {
        let plot = AKNodeOutputPlot(masterVolume, frame:AudioPlot.bounds)
        plot.plotType = .buffer
        plot.shouldFill = true
        plot.shouldMirror = true
        plot.color = UIColor.cyan
        plot.backgroundColor = UIColor.clear
        plot.tintColor = UIColor.magenta
        plot.gain = 1.2
        AudioPlot.addSubview(plot)
        
        
    }
    
   
    enum ControlTag: Int {
        
        case masterVol = 122
       
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
        // Build the keyboard
setupkeyb()
        
       
        // build the oscillators
        
        
mixer = AKMixer(osc, osc2)
        
        
        filter = AKRolandTB303Filter(mixer)
        
        
masterVolume = AKBooster(filter)
       
    
        AudioKit.output = masterVolume
        AudioKit.start()
        
        setDelegates()
        setDefaultValues()
        setupPlot()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func filterlen(_ sender: UISlider) { filter.resonanceAsymmetry = (sender.value * filter.resonance + 2)
    }
    
    @IBAction func filtercut(_ sender: UISlider) { filter.distortion = (sender.value * 2.0)
    }
    
    @IBAction func filterres(_ sender: UISlider) {
        filter.resonance = (sender.value * 0.7)
    }
    
    @IBAction func filter4(_ sender: UISlider) {
        filter.cutoffFrequency = (sender.value * 600 + 900)
        
     
        
    }
    
    
    
    
    // KEYBOARD NOTES
    
        func noteOn(note: MIDINoteNumber) {
            osc.play(noteNumber: note, velocity: 100)
            osc2.play(noteNumber: note, velocity: 100)        }
            func noteOff(note: MIDINoteNumber) {
                osc.stop(noteNumber: note)
                osc2.stop(noteNumber: note)
                
    }
    
    // WHAT DO THEY CONTROL
    
     func setupKnobValues() {
      processone.maximum = 1_000
        processone.value = osc.index
        processtwo.maximum = 2.0
        processtwo.value = osc.pitchBend
        processthree.maximum = 1_000
        processthree.value = osc2.index
        masterVolKnob.maximum = 2.0
        masterVolKnob.value = masterVolume.gain
attack.maximum = 1.0
        attack.value = osc.attackDuration
        attack.value = osc2.attackDuration
        decay.maximum = 1.0
        decay.value = osc.decayDuration
        decay.value = osc2.decayDuration
        sustain.maximum = 1.0
        sustain.value = osc.sustainLevel
        sustain.value = osc2.sustainLevel
        rellength.maximum = 2.0
        rellength.value = osc.releaseDuration
        rellength.value = osc2.releaseDuration
        lforate.maximum = 3.0
        lforate.value = osc.vibratoRate
        lforate.value = osc2.vibratoRate
        lfodep.maximum = 1.0
        lfodep.value = osc.vibratoDepth
        lfodep.value = osc2.vibratoDepth
        ramptme.maximum = 1.0
        ramptme.value = osc2.rampTime
        
    }
    
    func setDefaultValues() {
   filter.cutoffFrequency = 1_350
        filter.resonance = 0.5
        filter.distortion = 2.0
        filter.resonanceAsymmetry = 0.5
        osc.attackDuration = 0.0
        osc.decayDuration = 0.0
        osc.sustainLevel = 1.0
        osc.releaseDuration = 0.0
        osc2.attackDuration = 0.0
        osc2.decayDuration = 0.1
        osc2.sustainLevel = 1.0
        osc2.releaseDuration = 0.0
        osc.index = 1
        osc.pitchBend = 0
        osc2.index = 1
        osc2.rampTime = 0
        osc.vibratoDepth = 0
        osc.vibratoRate = 0
        osc2.rampTime = 0.1
        masterVolume.gain = 2
        //
        setupKnobValues()
    }
    
   
    
}


// KNOB DELEGATES......MAKE IT DO SOMETHING
    extension ViewController: KnobDelegate {
        
        func updateKnobValue(_ value: Double, tag: Int) {
            masterVolume.gain = Double(masterVolKnob.knobValue)
          osc.index = Double(processone.knobValue)
            osc.pitchBend = Double(processtwo.knobValue)
            osc2.index = Double(processthree.knobValue)
            osc.attackDuration = Double(attack.knobValue)
            osc2.attackDuration = Double(attack.knobValue)
            osc.decayDuration = Double(decay.knobValue + 1)
            osc2.decayDuration = Double(decay.knobValue)
            osc.sustainLevel = Double(sustain.knobValue)
            osc2.sustainLevel = Double(sustain.knobValue)
            osc2.releaseDuration = Double(rellength.knobValue)
            osc.releaseDuration = Double(rellength.knobValue)
            osc.vibratoRate = Double(lforate.knobValue)
            osc2.vibratoRate = Double(lforate.knobValue)
            osc.vibratoDepth = Double(lfodep.knobValue)
            osc2.vibratoDepth = Double(lfodep.knobValue)
            osc2.rampTime = Double(ramptme.knobValue)
            switch tag {
            // Master
            case ControlTag.masterVol.rawValue:
               
               masterVolume.gain = value
                
           
            default:
                break
            }
            
        }
}

// Set Delegates

extension ViewController {
    
    func setDelegates() {
masterVolKnob.delegate = self
        processone.delegate = self
        processtwo.delegate = self
        processthree.delegate = self
        attack.delegate = self
        decay.delegate = self
        sustain.delegate = self
        rellength.delegate = self
        lforate.delegate = self
        lfodep.delegate = self
        ramptme.delegate = self
    
   
        
    }

}

