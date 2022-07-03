import JavaScriptKit
import JavaScriptEventLoop

let alert = JSObject.global.alert.function!
let document = JSObject.global.document

var divElement = document.createElement("div")
divElement.innerText = "Hello, world"
_ = document.body.appendChild(divElement)

var buttonElement = document.createElement("button")
buttonElement.innerText = "This will crash iOS MobileSafari"
buttonElement.onclick = .object(JSClosure { _ in
    var s: String = ""
    print("about to do a big loop!")
    for i in 0..<90000 {
       s = s + "\(i)"
    }
    print(s)
    alert("This will never execute on iOS16")
    return .undefined
})
_ = document.body.appendChild(buttonElement)

var buttonElement2 = document.createElement("button")
buttonElement2.innerText = "This will not crash iOS MobileSafari (small Loop)"
buttonElement2.onclick = .object(JSClosure { _ in
    var s: String = ""
    print("about to do a small loop!")
    for i in 0..<200 {
       s = s + "\(i)"
    }
    print(s)
    alert("This didn't crash becuase it is under ~200 iterations.")
    return .undefined
})
_ = document.body.appendChild(buttonElement2)

var codeElement = document.createElement("textarea")
codeElement.style.object!.width = "450pt"
codeElement.style.object!.height = "300pt"
codeElement.style.object!.display = "block"
codeElement.innerHTML = ##"""
If you do not import WebAPIKit, the crash does not occur. I do not believe it is WebAPIKit necessarily that is doing it. Probably Foundation but importing WebAPITKit was the easiest way to get a lot of Foundation to import. 

This project imports WebAPIKit, but the crash also occurred for WASM binaries that are complied using Swift 5.5 and what was DOMKit. I have a feeling this crash is caused by iOS 16 Beta (both 1 and 2). This only occurrs for large loops. If the loop is small (say under 200 iterations), the bug does not occur.  This crash only happens in MobileSafari on iOS 16 Betas.

I would like to file a bug report with Apple but 1) you know how that goees and 2) I am not even sure that the diagnostic information is enough and 3) I am very fearful that this is a bug that apple will not fix for the final, so I might want to figure out if there is a work around.

This is the code
buttonElement.onclick = .object(JSClosure { _ in
    var s: String = ""
    print("about to do a big loop!")
    for i in 0..<90000 {
       s = s + "\(i)"
    }
    print(s)
    alert("This will never execute on iOS16")
    return .undefined
})
"""##
_ = document.body.appendChild(codeElement)



private let jsFetch = JSObject.global.fetch.function!
func fetch(_ url: String) -> JSPromise {
    JSPromise(jsFetch(url).object!)!
}

JavaScriptEventLoop.installGlobalExecutor()

struct Response: Decodable {
    let uuid: String
}

var asyncButtonElement = document.createElement("button")
asyncButtonElement.innerText = "Fetch UUID demo"
asyncButtonElement.onclick = .object(JSClosure { _ in
    Task {
        do {
            let response = try await fetch("https://httpbin.org/uuid").value
            let json = try await JSPromise(response.json().object!)!.value
            let parsedResponse = try JSValueDecoder().decode(Response.self, from: json)
            alert(parsedResponse.uuid)
        } catch {
            print(error)
        }
    }

    return .undefined
})

_ = document.body.appendChild(asyncButtonElement)
