export default class VideoSizeSelectElement extends HTMLElement {
    constructor() {
        super()
        this.labelCount = document.createElement("label")
        this.labelSize = document.createElement("label")
        this.video = document.getElementById("video")
        this.video.onloadedmetadata = this.setShowSize
        this.video.onresize = this.setShowSize
    }

    connectedCallback() {
        const labelWidthHeight = document.createElement("label")
        shadow.append(labelWidthHeight)
        shadow.append(this.labelCount)
        shadow.append(document.createElement("br"))
        shadow.append(this.labelSize)
        shadow.append(document.createElement("br"))
        shadow.append(selectWidthValue)
        shadow.append(document.createElement("br"))
        shadow.append(this.video)
    }

    // @params MediaStream
    // @return void
    set srcObject(stream) {
        if (this.stream) this.stream.removeEventListener("addtrack", this.setShowTrackCount)
        if (this.stream) this.stream.removeEventListener("removetrack", this.setShowTrackCount)
        this.stream = stream
        this.stream.addEventListener("addtrack", this.setShowTrackCount)
        this.stream.addEventListener("removetrack", this.setShowTrackCount)
        this.setShowTrackCount(stream)
        this.video.srcObject = stream
    }

    setShowSize = () => this.labelSize.innerText = `Raw Resolution: ${this.video.videoWidth}x${this.video.videoHeight}`
    setShowTrackCount = () => this.labelCount.innerText = `Audio Track Count: ${this.stream.getAudioTracks().length}, Video Track Count: ${this.stream.getVideoTracks().length}`
}
