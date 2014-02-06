package core.resource {

	public class MovieClipData {
		public var m_vectBitmapFrames:Vector.<BitmapFrame>;

		public function MovieClipData() {
			m_vectBitmapFrames=new Vector.<BitmapFrame>();
		}

		public function dispose():void {
			for (var i:* in m_vectBitmapFrames) {
				if (m_vectBitmapFrames[i] != null) {
					m_vectBitmapFrames[i].dispose();
					m_vectBitmapFrames[i]=null;
					delete m_vectBitmapFrames[i];
				}
			}
			m_vectBitmapFrames=null;
		}

		public function clear():void {
			for (var i:* in m_vectBitmapFrames) {
				if (m_vectBitmapFrames[i] != null) {
					m_vectBitmapFrames[i]=null;
					delete m_vectBitmapFrames[i];
				}
			}
			m_vectBitmapFrames=null;
		}

		public function get length():int {
			if (m_vectBitmapFrames == null)
				return 0;
			return m_vectBitmapFrames.length;
		}
	}
}
