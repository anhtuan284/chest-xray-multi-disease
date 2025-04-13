SEARCH_PROMPT_TEMPLATE="""
Dựa trên tài liệu về bệnh lý ngực, hãy cung cấp thông tin về: "{user_query}".

Yêu cầu:
- Trả lời bằng tiếng Việt 100% trừ các thuật ngữ chuyên ngành.z
- Thông tin phải chính xác và dựa trên tài liệu
- Nêu rõ nguồn tài liệu (Bao gồm trang và tên file) nếu có
- Cung cấp thông tin đầy đủ nhưng súc tích

Định dạng trả lời dưới dạng chuỗi hiển thị được trên màn hình di động:
- Câu trả lời: [Nội dung câu trả lời bằng tiếng Việt]
- Nguồn: [Tên tài liệu, trang số]

"""