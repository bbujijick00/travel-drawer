import Foundation

/// A handful of sample places so the app has something to show on first launch.
/// Photos are empty on purpose — the design uses striped placeholders for any
/// place without a real photo (see `PhotoPlaceholder`).
enum SeedData {
    static var places: [Place] {
        [
            Place(
                name: "온기정 냉면",
                tab: .visited,
                category: .food,
                region: "서울 을지로",
                tags: ["평양냉면", "웨이팅있음"],
                links: [PlaceLink(icon: "📷", label: "인스타그램 게시물", url: "https://instagram.com")],
                status: .open,
                lastCheckedAt: Date().addingTimeInterval(-86400 * 3),
                sub: "노포 · 냉면 전문",
                addr: "서울 중구 을지로 123",
                hours: "11:00 - 21:00 (매주 월요일 휴무)",
                access: "을지로3가역 4번 출구 도보 3분",
                visitDate: Date().addingTimeInterval(-86400 * 30),
                memo: "육수가 슴슴하고 좋았음. 다음엔 회냉면도 먹어보기.",
                isHearted: true
            ),
            Place(
                name: "낮잠 카페",
                tab: .visited,
                category: .cafe,
                region: "서울 연남동",
                tags: ["조용함", "노트북가능"],
                status: .changed,
                lastCheckedAt: Date().addingTimeInterval(-86400 * 40),
                sub: "루프탑 카페",
                addr: "서울 마포구 연남동 45-6",
                hours: "10:00 - 22:00",
                access: "연남동 사거리에서 도보 5분",
                visitDate: Date().addingTimeInterval(-86400 * 60),
                memo: "루프탑 자리 예약 추천.",
                isHearted: false
            ),
            Place(
                name: "산책 게스트하우스",
                tab: .visited,
                category: .stay,
                region: "강원 강릉",
                tags: ["오션뷰", "반려동물불가"],
                status: .open,
                lastCheckedAt: Date().addingTimeInterval(-86400 * 10),
                sub: "게스트하우스",
                addr: "강원 강릉시 solongro 12",
                hours: "체크인 15:00 / 체크아웃 11:00",
                access: "강릉역에서 택시 15분",
                visitDate: Date().addingTimeInterval(-86400 * 200),
                memo: "",
                isHearted: true
            ),
            Place(
                name: "구도심 전망대",
                tab: .wish,
                category: .sight,
                region: "부산 중구",
                tags: ["야경", "무료"],
                status: .open,
                sub: "전망대",
                addr: "부산 중구 대청로 100",
                hours: "09:00 - 21:00",
                access: "부산역에서 버스 15분",
                memo: ""
            ),
            Place(
                name: "새벽 어시장 식당",
                tab: .wish,
                category: .food,
                region: "부산 중구",
                tags: ["회", "새벽영업"],
                status: .closed,
                lastCheckedAt: Date().addingTimeInterval(-86400 * 90),
                sub: "해산물",
                addr: "부산 중구 자갈치로 33",
                hours: "확인 필요",
                access: "자갈치역 3번 출구",
                memo: "폐업했다는 리뷰 있음, 확인 필요."
            ),
            Place(
                name: "모래언덕 카페",
                tab: .wish,
                category: .cafe,
                region: "제주 구좌읍",
                tags: ["바다뷰"],
                status: .open,
                sub: "오션뷰 카페",
                addr: "제주 구좌읍 해맞이해안로 200",
                hours: "10:00 - 19:00",
                access: "제주공항에서 차량 40분",
                memo: ""
            )
        ]
    }
}
