//
//  ShowroomPreviews.swift
//  Split
//
//  Created by Hugo Queinnec on 31/08/2022.
//

import SwiftUI
import Vision


struct ShowroomPreviews: View {
    @State var previewNumber = 1
    
    var body: some View {
        Group {
            switch previewNumber {
            case 2:
                Scan_Previews.previews
            case 3:
                Attribution_Previews.previews
            case 4:
                Results_Previews.previews
            case 1:
                Start_Previews.previews
            default:
                Text("Hello")
            }
        }
    }
}

struct ShowroomPreviews_Previews: PreviewProvider {
    static var previews: some View {
        ShowroomPreviews()
    }
}

//__________________

func previewModel(_ previewNumber: Int) -> ModelData {
    let model = ModelData()
    if previewNumber != 1 {
        model.users = [User(name: "Hugo"), User(name: "Alicia"), User(name: "Thomas")]
        model.currency = Currency(symbol: Currency.SymbolType.euro)
        model.images = [IdentifiedImage(id: "1111", image: UIImage(named: "sample_receipt_scan"))]
        model.receiptName = "Local Food Market"
        
        model.parameters.tricountList.append(Tricount(tricountName: "Shared Flat", tricountID: "", names: ["Hugo", "Alicia", "Thomas"], status: ""))
        
        var lowercase = true
        if previewNumber == 1 || previewNumber == 2 {
            lowercase = false
        }
        
        var middleItemName = "FILET POULET CRF"
        var middleItemPrice = 5.32
        if previewNumber==2 {
            middleItemName = "Basmati Rice 500g"
            middleItemPrice = 1.49
        }
        
        //model.tipRate = 21
        model.taxRate = 8.5
        model.taxEvenly = false
        //model.tipEvenly = true
        
        //model.currency = Currency(symbol: Currency.SymbolType.dollar)
        
        model.listOfProductsAndPrices = [
            PairProductPrice(id: "B5B3B40E-F71E-418F-8D8A-8C9ED951F728", name: lowercase ? "Guava Juice 1L" : "1L NECTAR GOYAVE", price: 3.0, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.146138, y: 0.733703, width: 0.725036, height: 0.0208154)), chosenBy: [model.users[0].id]),
            PairProductPrice(id: "87EB6473-461F-44FB-894B-F457029403E5", name: lowercase ? "Camembert Français 250g" : "250G CAMEMBERT CDL", price: 1.75, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.106122, y: 0.717897, width: 0.766941, height: 0.0196032)), chosenBy: [model.users[0].id, model.users[2].id]),
            PairProductPrice(id: "365D904B-EE0A-4ECD-B1C4-6CB58F2EB83F", name: lowercase ? "2x125g Shortbread" : "2X125G PALETS BRET", price: 1.3, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.108054, y: 0.701252, width: 0.766469, height: 0.0195545)), chosenBy: [model.users[1].id, model.users[2].id]),
            PairProductPrice(id: "F4A440FC-472C-4289-81F6-EA766E3C264C", name: lowercase ? "Bolognaise Sauce 400g" : "400G SCE BOLOGNAI.", price: 2.15, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.108002, y: 0.685683, width: 0.766056, height: 0.0185758)), chosenBy: [model.users[2].id]),
            PairProductPrice(id: "8B3629F3-B736-4005-BD8E-B9BEFCFEEA60", name: lowercase ? "Linguine Collezione" : "500G COLLEZIONE", price: 1.19, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.108132, y: 0.668968, width: 0.765657, height: 0.0180166)), chosenBy: [model.users[0].id, model.users[1].id]),
            PairProductPrice(id: "46C88D76-4790-46F6-9423-9E9DB03B2385", name: lowercase ? "Laundry Pods" : "50ML DEO NIVEA", price: 8.25, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.162281, y: 0.652253, width: 0.709883, height: 0.0175031)), chosenBy: [model.users[0].id, model.users[1].id, model.users[2].id]),
            PairProductPrice(id: "80B428D9-4179-4911-A4C6-15FF967D19DF", name: lowercase ? "Toothpaste" : "75ML DENT PROT PAR", price: 5.55, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.163669, y: 0.618901, width: 0.709025, height: 0.0174288)), chosenBy: [model.users[0].id, model.users[1].id]),
            PairProductPrice(id: "BB51DAE2-4BAD-4D95-91C9-CC0EA6C15859", name: lowercase ? "Almond Chocolate" : "BAD I8 COMPL DURE", price: 2.38, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.113621, y: 0.603561, width: 0.761421, height: 0.016094)), chosenBy: [model.users[1].id, model.users[2].id]),
            PairProductPrice(id: "DF63F5FD-FCC0-4CF0-915B-B84443FC5939", name: lowercase ? "Zucchinis" : "COURGETTE", price: 2.19, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.113158, y: 0.587573, width: 0.760522, height: 0.0163151)), chosenBy: [model.users[0].id, model.users[1].id, model.users[2].id]),
            PairProductPrice(id: "2069589A-556E-48A1-A58B-27C37EE597B8", name: lowercase ? "Lemon/Lime" : "DCH LPM VERV CITRO", price: 3.84, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.113012, y: 0.570444, width: 0.76138,  height:0.0168982)), chosenBy: [model.users[0].id, model.users[2].id]),
            PairProductPrice(id: "573CEBBE-87C2-4F3D-BD67-CEEEFE0B9911", name: lowercase ? "Basmati Rice 8x500g" : middleItemName, price: middleItemPrice, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.114499, y: 0.538881, width: 0.75927,  height:0.0151428)), chosenBy: [model.users[0].id]),
            PairProductPrice(id: "D900EB73-F2B2-4396-B70F-25A679B8079B", name: lowercase ? "Butter Brioche" : "GACHE TRANCHE FOUR", price: 2.44, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.113158, y: 0.522892, width: 0.762409, height: 0.0146631)), chosenBy: [model.users[0].id, model.users[2].id]),
            PairProductPrice(id: "D6F5F6D2-FB7A-4562-8310-F5F6322EC351", name: lowercase ? "Lip Balm" : "LABELLO ORIGINAL", price: 3.28, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.111475, y: 0.505631, width: 0.764571, height: 0.0153066)), chosenBy: [model.users[0].id, model.users[1].id, model.users[2].id]),
            PairProductPrice(id: "D041D2CF-7FC6-4D49-AF7E-7F6EF68E6217", name: lowercase ? "Dishwasher Soap" : "PAIC XLS ACTIF FRD", price: 2.05, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.113443, y: 0.473182, width: 0.762698, height: 0.0149828)), chosenBy: [model.users[0].id, model.users[2].id]),
            PairProductPrice(id: "F6C0BB99-A549-48D9-830A-778B9602FB8D", name: lowercase ? "Chicken Fillet" : "ORAL B BROSSETTES", price: 10.9, isNewItem: false, imageId: Optional("1111"), box: VNDetectedObjectObservation(boundingBox: CGRect(x: 0.167544, y: 0.490189, width: 0.707182, height: 0.0145087)), chosenBy: [model.users[0].id, model.users[2].id])]
    }
    
    return model
}


// TODO: before running previews, add the Split! .json files to the Files App, and remove TipsView from settings

// PREVIEW 1
struct Scan_Previews: PreviewProvider {
    static var previews: some View {
        FirstListView(showScanningResults: .constant(true), nothingFound: .constant(true))
            .environmentObject(previewModel(1))
    }
}

// PREVIEW 2 (check the 2 first names)
struct Attribution_Previews: PreviewProvider {
    static var previews: some View {
        AttributionView(itemCounter: 10)
            .environmentObject(previewModel(2))
    }
}

// PREVIEW 3
struct Results_Previews: PreviewProvider {
    static var previews: some View {
        ResultView()
            .environmentObject(previewModel(3))
    }
}

// PREVIEW 4
struct Start_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
            .environmentObject(previewModel(4))
    }
}
